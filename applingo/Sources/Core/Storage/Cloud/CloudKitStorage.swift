import Foundation

struct CloudKitStorage: AbstractStorage {
    private let local: AbstractStorage
    internal let cloud: CloudKit

    init(
        local: AbstractStorage = UserDefaultsStorage(),
        cloud: CloudKit = CloudKit()
    ) {
        self.local = local
        self.cloud = cloud
    }

    func getValue(for key: String) -> String {
        let localEncoded = local.getValue(for: key)
        let localData = decodeValue(localEncoded)

        return localData.value
    }

    func setValue(_ value: String, for key: String) {
        let encoded = encodeValue(value)
        local.setValue(encoded, for: key)
        
        Task {
            await cloud.saveValue(encoded, for: key)
        }
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
