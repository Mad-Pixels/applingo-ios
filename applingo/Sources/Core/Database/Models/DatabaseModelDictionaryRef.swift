import Foundation

/// A minimal model representing a dictionary reference with a name and GUID.
struct DatabaseModelDictionaryRef: Identifiable, Codable, Equatable, Hashable {
    /// Using `guid` as the unique identifier.
    var id: String { guid }
    let guid: String
    let name: String
}
