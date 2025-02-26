import SwiftUI

// MARK: - String Extensions

extension String {
    /// Returns a copy of the string with the first letter capitalized.
    var capitalizedFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    /// Returns a copy of the string with trailing whitespace trimmed.
    var trimmedTrailingWhitespace: String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    /// Indicates whether the string contains at least one emoji.
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.properties.isEmoji }
    }
    
    /// Returns the number of emojis present in the string.
    var emojiCount: Int {
        return unicodeScalars.filter { $0.properties.isEmoji }.count
    }
    
    /// Returns the count of words in the string.
    var wordCount: Int {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }.count
    }
    
    /// Computes a complexity score for the text based on its length, word count, and emoji count.
    ///
    /// The score is calculated as a weighted sum:
    /// - 40% contribution from the total length,
    /// - 40% contribution from the word count,
    /// - 20% contribution from the emoji count.
    var complexityScore: Double {
        let words = Double(wordCount)
        let emojis = Double(emojiCount)
        let length = Double(count)
        
        // Complexity is calculated as a weighted sum of length, word count, and emoji count.
        return (length * 0.4) + (words * 0.4) + (emojis * 0.2)
    }
}
