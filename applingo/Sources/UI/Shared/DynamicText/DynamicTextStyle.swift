import SwiftUI

/// A style configuration for the DynamicText component, defining its appearance and dynamic font sizing behavior.
/// It includes properties for colors, fonts, text alignment, spacing, and emoji handling.
struct DynamicTextStyle {
    
    // MARK: - Appearance Properties
    let textColor: Color
    let baseFont: Font
    let alignment: TextAlignment
    let lineSpacing: CGFloat
    let letterSpacing: CGFloat
    let allowsTightening: Bool
    
    // MARK: - Font Size Properties
    let maxFontSize: CGFloat
    let minFontSize: CGFloat
    let optimalFontSizeRange: ClosedRange<CGFloat>
    
    // MARK: - Emoji Handling
    let emojiScale: CGFloat
    
    //
    let lineBreakMode: NSLineBreakMode
    let wordWrapping: Bool
    
    // MARK: - Dynamic Font Sizing
    /// Calculates the optimal font size based on the provided text.
    ///
    /// The calculation uses the text's complexity score (derived from length, word count, and emoji count)
    /// and adjusts the base size accordingly. Additionally, if the text contains emojis, the font size
    /// is slightly reduced.
    ///
    /// - Parameter text: The input text used to determine the font size.
    /// - Returns: The optimal font size as a `CGFloat`.
    func calculateOptimalFontSize(for text: String) -> CGFloat {
        let complexity = text.complexityScore
        let wordLength = text.components(separatedBy: " ").map { $0.count }.max() ?? 0

        
        // Determine the base font size based on text complexity.
        let baseSize: CGFloat
            switch complexity {
            case 0...30:
                baseSize = maxFontSize
            case 31...60:
                baseSize = maxFontSize * 0.9
            case 61...100:
                baseSize = maxFontSize * 0.8
            default:
                baseSize = maxFontSize * 0.7
            }
        
        let wordLengthAdjustment: CGFloat
            switch wordLength {
            case 0...10:
                wordLengthAdjustment = 0
            case 11...15:
                wordLengthAdjustment = -4
            case 16...20:
                wordLengthAdjustment = -8
            default:
                wordLengthAdjustment = -12
            }
        
        // Adjust font size if the text contains emojis.
        let emojiAdjustment: CGFloat = text.containsEmoji ? -2.0 : 0.0
            let adjustedSize = baseSize + wordLengthAdjustment + emojiAdjustment
            
            return max(minFontSize, min(maxFontSize, adjustedSize))
    }
}

// MARK: - Convenience Initializer
extension DynamicTextStyle {
    /// Creates a `DynamicTextStyle` instance configured for the main game theme.
    ///
    /// - Parameter theme: An `AppTheme` instance providing the theme colors.
    /// - Returns: A configured `DynamicTextStyle` instance.
    static func gameMain(_ theme: AppTheme) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            baseFont: .system(size: 32, weight: .bold),
            alignment: .center,
            lineSpacing: 4,
            letterSpacing: 0.8,
            allowsTightening: true,
            maxFontSize: 32,
            minFontSize: 14,
            optimalFontSizeRange: 14...32,
            emojiScale: 0.9,
            lineBreakMode: .byTruncatingTail,
            wordWrapping: false
        )
    }
}
