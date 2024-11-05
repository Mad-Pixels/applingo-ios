import Foundation

struct CategoryItemModel: Codable, Equatable, Hashable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
