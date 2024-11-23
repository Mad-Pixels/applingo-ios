import Foundation

struct CategoryItem: Codable, Equatable, Hashable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct CategoryItemModel: Codable, Equatable, Hashable {
    let frontCategory: [CategoryItem]
    let backCategory: [CategoryItem]
    
    init(frontCategory: [CategoryItem], backCategory: [CategoryItem]) {
        self.frontCategory = frontCategory
        self.backCategory = backCategory
    }
    
    enum CodingKeys: String, CodingKey {
        case frontCategory = "front_category"
        case backCategory = "back_category"
    }
}
