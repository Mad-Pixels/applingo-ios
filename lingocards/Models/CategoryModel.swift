import Foundation

struct CategoryItem: Codable, Equatable, Hashable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
