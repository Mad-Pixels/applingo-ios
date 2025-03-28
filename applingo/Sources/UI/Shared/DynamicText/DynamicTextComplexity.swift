import Foundation

struct DynamicTextComplexity {
    let length: Int
    let wordCount: Int
    let emojiCount: Int
    let uppercaseRatio: Double
    let punctuationCount: Int
    
    /// Computes the overall complexity score as a weighted sum of the components.
    /// The result ranges from 0 to 100, where higher values indicate a more complex text.
    var score: Double {
        // Normalizing the metrics to a 0-100 range
        let maxLength: Double = 200
        let maxWords: Double = 50
        let maxEmojis: Double = 10
        
        let normalizedLength = min(Double(length) / maxLength, 1.0) * 100
        let normalizedWords = min(Double(wordCount) / maxWords, 1.0) * 100
        let normalizedEmojis = min(Double(emojiCount) / maxEmojis, 1.0) * 100
        let normalizedUppercase = uppercaseRatio * 100
        let normalizedPunctuation = min(Double(punctuationCount) / 20.0, 1.0) * 100
        
        // Applying weights to each metric
        let lengthScore = normalizedLength * 0.3
        let wordScore = normalizedWords * 0.3
        let emojiScore = normalizedEmojis * 0.2
        let uppercaseScore = normalizedUppercase * 0.1
        let punctuationScore = normalizedPunctuation * 0.1
        
        return lengthScore + wordScore + emojiScore + uppercaseScore + punctuationScore
    }
}
