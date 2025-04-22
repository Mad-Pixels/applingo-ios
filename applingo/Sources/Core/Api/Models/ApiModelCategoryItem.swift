import Foundation

/// A model representing a category item used for filtering dictionaries.
struct CategoryItem: Codable, Equatable, Hashable {
    // MARK: - Properties

    /// The unique code representing the category.
    let code: String

    // MARK: - Initialization

    /// Initializes a new category item.
    /// - Parameter code: The unique code for the category.
    init(code: String) {
        self.code = code
    }
    
    /// Returns the localized name of the language represented by the code.
    /// - Parameter locale: The locale in which to display the language name (defaults to current locale).
    /// - Returns: The localized language name, or the code itself if no name is found.
    func localizedLanguageName(in locale: Locale = .current) -> String {
        if let languageName = locale.localizedString(forLanguageCode: code) {
            return languageName
        }
        return code
    }
}

/// A model representing a categorized item used in dictionary queries.
struct ApiModelCategoryItem: Codable, Equatable, Hashable {
    // MARK: - Properties

    /// The categories for the front side of the dictionary.
    let frontCategory: [CategoryItem]

    /// The categories for the back side of the dictionary.
    let backCategory: [CategoryItem]

    // MARK: - Initialization

    /// Initializes a categorized item model.
    /// - Parameters:
    ///   - frontCategory: The categories for the front side.
    ///   - backCategory: The categories for the back side.
    init(frontCategory: [CategoryItem], backCategory: [CategoryItem]) {
        self.frontCategory = frontCategory
        self.backCategory = backCategory
    }

    // MARK: - Coding Keys

    /// Maps JSON keys to property names.
    enum CodingKeys: String, CodingKey {
        case frontCategory = "front_side"
        case backCategory = "back_side"
    }
}
