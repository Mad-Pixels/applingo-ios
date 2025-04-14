import Foundation

struct CloudKitStorage: AbstractStorage {
    private let local: AbstractStorage
    private let cloud: CloudKit

    init(
        local: AbstractStorage = UserDefaultsStorage(),
        cloud: CloudKit = CloudKit()
    ) {
        self.local = local
        self.cloud = cloud
    }

    func getValue(for key: String) -> String {
        let localValue = local.getValue(for: key)
        if !localValue.isEmpty {
            return localValue
        }

        let cloudValue = cloud.fetchValue(for: key)
        if !cloudValue.isEmpty {
            local.setValue(cloudValue, for: key)
        }
        return cloudValue
    }

    func setValue(_ value: String, for key: String) {
        local.setValue(value, for: key)
        cloud.saveValue(value, for: key)
    }
}
