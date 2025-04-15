import Foundation

struct CloudKitStorage: AbstractStorage {
    private let syncQueue = DispatchQueue(label: "com.app.cloudkitstorage.sync", qos: .utility)
    private let initialSyncDelay: UInt64 = 300_000_000_000
    private let maxSyncDelay: UInt64 = 1_800_000_000_000
    private let minSyncDelay: UInt64 = 60_000_000_000
    private let syncBackoffMultiplier: Double = 1.5
    private let pendingOperationsStorage: AbstractStorage
    private let local: AbstractStorage
    
    internal let cloud: CloudKit

    init(
        local: AbstractStorage = UserDefaultsStorage(),
        cloud: CloudKit = CloudKit(),
        pendingOperationsStorage: AbstractStorage = UserDefaultsStorage()
    ) {
        self.pendingOperationsStorage = pendingOperationsStorage
        self.local = local
        self.cloud = cloud

        processPendingOperations()
    }

    func getValue(for key: String) -> String {
        let localEncoded = local.getValue(for: key)
        let localData = decodeValue(localEncoded)
        
        Task {
            await syncWithCloud(key: key, localTimestamp: localData.timestamp)
        }
        return localData.value
    }
    
    func getValueAsync(for key: String) async -> String {
        let localEncoded = local.getValue(for: key)
        let localData = decodeValue(localEncoded)
        
        await syncWithCloud(key: key, localTimestamp: localData.timestamp)
        
        let updatedLocalEncoded = local.getValue(for: key)
        let updatedLocalData = decodeValue(updatedLocalEncoded)
        
        return updatedLocalData.value
    }

    func setValue(_ value: String, for key: String) {
        let encoded = encodeValue(value)
        local.setValue(encoded, for: key)
        
        Task {
            let success = await cloud.saveValue(encoded, for: key)
            
            if !success {
                addPendingOperation(type: .save, key: key, value: encoded)
            }
        }
    }
    
    internal func addPendingOperation(type: CloudPendingOperationType, key: String, value: String) {
        let id = UUID().uuidString
        let operationsKey = "pending_operations"
        let operation = CloudPendingOperation(
            id: id,
            type: type,
            key: key,
            value: value,
            timestamp: Int(Date().timeIntervalSince1970)
        )
        
        syncQueue.sync {
            var operations = getPendingOperations()
            
            let existingIndex = operations.firstIndex { $0.key == key && $0.type == type }
            if let index = existingIndex {
                operations[index] = operation
            } else {
                operations.append(operation)
            }
            
            savePendingOperations(operations)
            
            Logger.debug(
                "[CloudKitStorage] Added pending operation",
                metadata: [
                    "key": key,
                    "type": type.rawValue,
                    "total_pending": operations.count
                ]
            )
        }
    }
    
    private func syncWithCloud(key: String, localTimestamp: Int) async {
        guard cloud.checkCloudAvailability() else {
            Logger.debug(
                "[CloudKitStorage] Sync skipped — cloud not available",
                metadata: [
                    "key": key
                ]
            )
            return
        }
        
        do {
            let cloudEncoded = try await cloud.fetchValue(for: key)
            if cloudEncoded.isEmpty {
                return
            }
            
            let cloudData = decodeValue(cloudEncoded)
            
            if cloudData.timestamp > localTimestamp {
                local.setValue(cloudEncoded, for: key)
                
                Logger.debug(
                    "[CloudKitStorage] Updated local data from cloud",
                    metadata: [
                        "key": key,
                        "local_timestamp": localTimestamp,
                        "cloud_timestamp": cloudData.timestamp
                    ]
                )
            } else if cloudData.timestamp < localTimestamp {
                let localEncoded = local.getValue(for: key)
                let success = await cloud.saveValue(localEncoded, for: key)
                
                Logger.debug(
                    "[CloudKitStorage] Updated cloud data from local",
                    metadata: [
                        "key": key,
                        "cloud_timestamp": cloudData.timestamp,
                        "local_timestamp": localTimestamp,
                        "success": success
                    ]
                )
                
                if !success {
                    addPendingOperation(type: .save, key: key, value: localEncoded)
                }
            }
        } catch {
            Logger.debug(
                "[CloudKitStorage] Failed to sync with cloud",
                metadata: [
                    "key": key,
                    "error": error.localizedDescription
                ]
            )
        }
    }
    
    private func processPendingOperations() {
        Task {
            var currentDelay = initialSyncDelay
            var consecutiveFailures = 0
            
            while true {
                let operations = getPendingOperations()
                
                if operations.isEmpty {
                    try? await Task.sleep(nanoseconds: initialSyncDelay)
                    currentDelay = initialSyncDelay
                    consecutiveFailures = 0
                    continue
                }
                
                Logger.debug(
                    "[CloudKitStorage] Processing pending operations",
                    metadata: [
                        "count": operations.count,
                        "current_delay_seconds": currentDelay / 1_000_000_000
                    ]
                )
                
                var successCount = 0
                
                for operation in operations {
                    if Task.isCancelled {
                        break
                    }
                    
                    if operation.type == CloudPendingOperationType.save {
                        let success = await cloud.saveValue(operation.value, for: operation.key)
                        if success {
                            removePendingOperation(id: operation.id)
                            successCount += 1
                        }
                    }
                }
                
                if successCount == operations.count {
                    currentDelay = max(currentDelay / 2, minSyncDelay)
                    consecutiveFailures = 0
                } else if successCount == 0 {
                    consecutiveFailures += 1
                    currentDelay = min(UInt64(Double(currentDelay) * syncBackoffMultiplier), maxSyncDelay)
                } else {
                    consecutiveFailures = 0
                    currentDelay = min(UInt64(Double(currentDelay) * 1.2), maxSyncDelay)
                }
                
                Logger.debug(
                    "[CloudKitStorage] Sync session completed",
                    metadata: [
                        "total_operations": operations.count,
                        "successful_operations": successCount,
                        "next_delay_seconds": currentDelay / 1_000_000_000
                    ]
                )
                
                try? await Task.sleep(nanoseconds: currentDelay)
            }
        }
    }
    
    private func removePendingOperation(id: String) {
        syncQueue.sync {
            var operations = getPendingOperations()
            let initialCount = operations.count
            operations.removeAll { $0.id == id }
            
            if operations.count < initialCount {
                savePendingOperations(operations)
                
                Logger.debug(
                    "[CloudKitStorage] Removed pending operation",
                    metadata: [
                        "id": id,
                        "remaining_operations": operations.count
                    ]
                )
            }
        }
    }
    
    private func getPendingOperations() -> [CloudPendingOperation] {
        let operationsKey = "pending_operations"
        let operationsJson = pendingOperationsStorage.getValue(for: operationsKey)
        
        if operationsJson.isEmpty {
            return []
        }
        
        guard let data = operationsJson.data(using: .utf8),
              let operations = try? JSONDecoder().decode([CloudPendingOperation].self, from: data) else {
            Logger.debug(
                "[CloudKitStorage] Failed to decode pending operations"
            )
            return []
        }
        
        return operations
    }
    
    private func savePendingOperations(_ operations: [CloudPendingOperation]) {
        let operationsKey = "pending_operations"
        guard let data = try? JSONEncoder().encode(operations),
              let json = String(data: data, encoding: .utf8) else {
            Logger.debug(
                "[CloudKitStorage] Failed to encode pending operations"
            )
            return
        }
        
        pendingOperationsStorage.setValue(json, for: operationsKey)
    }

    private func encodeValue(_ value: String) -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        return "\(value)::\(timestamp)"
    }

    private func decodeValue(_ raw: String) -> (value: String, timestamp: Int) {
        let components = raw.components(separatedBy: "::")
        if components.count == 2,
           let ts = Int(components[1]) {
            return (value: components[0], timestamp: ts)
        } else {
            return (value: raw, timestamp: 0)
        }
    }
}
