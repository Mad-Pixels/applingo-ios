import Foundation
import CloudKit

internal final class CloudKit {
    private let database = CKContainer.default().privateCloudDatabase
    private let recordType = "AppStorage"

    /// Fetches a value from CloudKit for the given key.
    func fetchValue(for key: String) -> String {
        Logger.debug(
            "[CloudKit] Fetch value",
            metadata: [
                "key": key
            ]
        )

        var result: String = ""
        let semaphore = DispatchSemaphore(value: 0)

        let recordID = CKRecord.ID(recordName: key)
        database.fetch(withRecordID: recordID) { record, error in
            defer { semaphore.signal() }

            if let error = error {
                Logger.debug(
                    "[CloudKit] Fetch failed",
                    metadata: [
                        "key": key,
                        "error": error.localizedDescription
                    ]
                )
                return
            }

            if let value = record?["value"] as? String {
                result = value
                Logger.debug(
                    "[CloudKit] Value fetched",
                    metadata: [
                        "key": key,
                        "value": value
                    ]
                )
            }
        }

        semaphore.wait()
        return result
    }

    /// Saves a value to CloudKit for the given key.
    func saveValue(_ value: String, for key: String) {
        Logger.debug(
            "[CloudKit] Save value",
            metadata: [
                "key": key,
                "value": value
            ]
        )

        let recordID = CKRecord.ID(recordName: key)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record["value"] = value as CKRecordValue

        database.save(record) { _, error in
            if let error = error {
                Logger.debug(
                    "[CloudKit] Save failed",
                    metadata: [
                        "key": key,
                        "error": error.localizedDescription
                    ]
                )
            } else {
                Logger.debug(
                    "[CloudKit] Value saved",
                    metadata: [
                        "key": key
                    ]
                )
            }
        }
    }
}
