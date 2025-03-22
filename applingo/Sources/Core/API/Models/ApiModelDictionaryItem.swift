import Foundation

/// A model representing an individual dictionary item in the response.
struct ApiModelDictionaryItem: Identifiable, Codable, Equatable, Hashable {
    /// The item identifier.
    let id: String
    
    /// The name of the dictionary.
    let name: String
    
    /// The category to which the dictionary belongs.
    let category: String
    
    /// The subcategory to which the dictionary belongs.
    let subcategory: String
    
    /// The author of the dictionary.
    let author: String
    
    /// The unique identifier for the dictionary.
    let dictionary: String
    
    /// A brief description of the dictionary.
    let description: String
    
    /// The creation timestamp of the dictionary.
    let created: Int
    
    /// The downloads count of the dictionary.
    let downloads: Int
    
    /// The dictionary language level.
    let level: String
    
    /// The dictionary topic.
    let topic: String
    
    /// The dictionary words count.
    let words: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, subcategory, author, dictionary, description, downloads, level, topic, words, created
    }
}

// MARK: - Search Methods

extension ApiModelDictionaryItem {
    /// Returns a combined searchable text for this dictionary.
    var searchableText: String {
        return [name, author, description]
            .map { $0.lowercased() }
            .joined(separator: " ")
    }

    /// Checks if the dictionary matches the provided search text.
    /// - Parameter searchText: The search string.
    /// - Returns: `true` if the dictionary matches, otherwise `false`.
    func matches(searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        
        // Разбиваем поисковый запрос на отдельные слова
        let searchTerms = searchText.lowercased().split(separator: " ")
        let searchableContent = searchableText
        
        // Проверяем, что все слова есть в контенте (AND условие)
        return searchTerms.allSatisfy { searchableContent.contains($0) }
    }
    
    /// Provides a formatted date string for the dictionary's creation date.
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(created))
        )
    }
}
