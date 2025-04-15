import Foundation
import CloudKit
import Network

internal final class CloudKit {
    private let networkMonitor = NWPathMonitor()
    private var isNetworkAvailable = false
    private let recordType = "ProfileData"
    private let container: CKContainer?
    private let database: CKDatabase?
    private let maxRetries = 3
    
    init() {
        if FileManager.default.ubiquityIdentityToken != nil {
            self.container = CKContainer.default()
            self.database = container?.privateCloudDatabase
        } else {
            Logger.debug(
                "[CloudKit] iCloud is not available — falling back to local only."
            )
            
            self.container = nil
            self.database = nil
        }
        
        setupNetworkMonitoring()
    }
    
    deinit {
        networkMonitor.cancel()
    }

    func fetchValue(for key: String) async throws -> String {
        guard let database else {
            Logger.debug(
                "[CloudKit] Fetch skipped — database not available",
                metadata: [
                    "key": key
                ]
            )
            return ""
        }
            
        guard isNetworkAvailable else {
            Logger.debug(
                "[CloudKit] Fetch skipped — network not available",
                metadata: [
                    "key": key
                ]
            )
            throw CloudKitError.networkUnavailable
        }

        let recordID = CKRecord.ID(recordName: key)
            
        var attempts = 0
        var lastError: Error?
            
        while attempts < maxRetries {
            do {
                let record = try await database.record(for: recordID)
                
                if let value = record["value"] as? String {
                    Logger.debug(
                        "[CloudKit] Value fetched",
                        metadata: [
                            "key": key,
                            "value": value
                        ]
                    )
                    return value
                }
                return ""
            } catch {
                lastError = error
                attempts += 1
                    
                Logger.debug(
                    "[CloudKit] Fetch attempt failed",
                    metadata: [
                        "key": key,
                        "attempt": attempts,
                        "error": error.localizedDescription
                    ]
                )
                    
                if attempts < maxRetries {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempts)) * 1_000_000_000))
                }
            }
        }
        Logger.debug(
            "[CloudKit] All fetch attempts failed",
            metadata: [
                "key": key,
                "error": lastError?.localizedDescription ?? "Unknown error"
            ]
        )
        throw lastError ?? CloudKitError.unknownError
    }

    func saveValue(_ value: String, for key: String) async -> Bool {
        guard let database else {
            Logger.debug(
                "[CloudKit] Save skipped — database not available",
                metadata: [
                    "key": key
                ]
            )
            return false
        }

        guard isNetworkAvailable else {
            Logger.debug(
                "[CloudKit] Save skipped — network not available",
                metadata: [
                    "key": key
                ]
            )
            return false
        }

        let recordID = CKRecord.ID(recordName: key)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record["value"] = value as CKRecordValue

        var attempts = 0

        while attempts < maxRetries {
            do {
                _ = try await database.save(record)
                Logger.debug(
                    "[CloudKit] Value saved",
                    metadata: [
                        "key": key
                    ]
                )
                return true
            } catch {
                attempts += 1
                    
                Logger.debug(
                    "[CloudKit] Save attempt failed",
                    metadata: [
                        "key": key,
                        "attempt": attempts,
                        "error": error.localizedDescription
                    ]
                )
                    
                if attempts < maxRetries {
                    try? await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempts)) * 1_000_000_000))
                }
            }
        }
        Logger.debug(
            "[CloudKit] All save attempts failed",
            metadata: [
                "key": key
            ]
        )
        return false
    }
    
    func checkCloudAvailability() -> Bool {
        return FileManager.default.ubiquityIdentityToken != nil && isNetworkAvailable
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.isNetworkAvailable = path.status == .satisfied
            Logger.debug(
                "[CloudKit] Network status changed",
                metadata: [
                    "status": path.status == .satisfied ? "connected" : "disconnected"
                ]
            )
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
}
