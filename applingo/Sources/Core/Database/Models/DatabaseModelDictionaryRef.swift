import Foundation
import GRDB

/// A minimal model representing a dictionary reference with a name and GUID.
struct DatabaseModelDictionaryRef: Identifiable, Codable, Equatable, Hashable, FetchableRecord {
    let id: Int
    let guid: String
    let name: String
}
