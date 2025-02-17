import SwiftUI

extension String {
    var capitalizedFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var trimmedTrailingWhitespace: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

// Расширение для анализа текста
extension String {
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.properties.isEmoji }
    }
    
    var emojiCount: Int {
        return unicodeScalars.filter { $0.properties.isEmoji }.count
    }
    
    var wordCount: Int {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }.count
    }
    
    // Определяем сложность текста
    var complexityScore: Double {
        let words = Double(wordCount)
        let emojis = Double(emojiCount)
        let length = Double(count)
        
        // Учитываем длину, количество слов и эмодзи
        return (length * 0.4) + (words * 0.4) + (emojis * 0.2)
    }
}
