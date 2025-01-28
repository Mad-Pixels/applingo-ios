import Foundation

struct CategoryItem: Codable, Equatable, Hashable {
    let code: String
    
    init(code: String) {
        self.code = code
    }
}

struct ApiModelCategoryItem: Codable, Equatable, Hashable {
    let frontCategory: [CategoryItem]
    let backCategory: [CategoryItem]
    
    init(frontCategory: [CategoryItem], backCategory: [CategoryItem]) {
        self.frontCategory = frontCategory
        self.backCategory = backCategory
    }
    
    enum CodingKeys: String, CodingKey {
        case frontCategory = "front_side"
        case backCategory = "back_side"
    }
}
