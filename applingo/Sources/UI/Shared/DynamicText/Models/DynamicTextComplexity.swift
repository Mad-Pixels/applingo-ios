/// A structure representing the complexity of a text based on its various properties.
internal struct TextComplexity {
    let length: Int
    let wordCount: Int
    let emojiCount: Int
    let uppercaseRatio: Double
    let punctuationCount: Int
    
    /// Computes the overall complexity score as a weighted sum of its components.
    var score: Double {
        let lengthScore = Double(length) * 0.3
        let wordScore = Double(wordCount) * 0.3
        let emojiScore = Double(emojiCount) * 0.2
        let uppercaseScore = uppercaseRatio * 0.1
        let punctuationScore = Double(punctuationCount) * 0.1
        
        return lengthScore + wordScore + emojiScore + uppercaseScore + punctuationScore
    }
}
