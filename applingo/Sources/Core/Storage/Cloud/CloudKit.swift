import Foundation
import CloudKit

internal final class CloudKit {
    private let recordType = "AppStorage"
    private let container: CKContainer?
    private let database: CKDatabase?
    
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

        let recordID = CKRecord.ID(recordName: key)
        
        do {
            let record = try await database.record(for: recordID)
            
            if let value = record["value"] as? String {
                Logger.debug(
                    "[CloudKit] Value fetched",
                    metadata: [
                        "key": key, "value": value
                    ]
                )
                return value
            }
            return ""
        } catch {
            Logger.debug(
                "[CloudKit] Fetch failed",
                metadata: [
                    "key": key,
                    "error": error.localizedDescription
                ]
            )
            return ""
        }
    }

    func saveValue(_ value: String, for key: String) async {
        guard let database else {
            Logger.debug(
                "[CloudKit] Save skipped — database not available",
                metadata: [
                    "key": key
                ]
            )
            return
        }

        let recordID = CKRecord.ID(recordName: key)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record["value"] = value as CKRecordValue

        do {
            _ = try await database.save(record)
            Logger.debug(
                "[CloudKit] Value saved",
                metadata: [
                    "key": key
                ]
            )
        } catch {
            Logger.debug(
                "[CloudKit] Save failed",
                metadata: [
                    "key": key,
                    "error": error.localizedDescription
                ]
            )
        }
    }
}
