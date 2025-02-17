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
        
        // Determine the base font size based on text complexity.
        let baseSize: CGFloat
        switch complexity {
        case 0...30:
            baseSize = maxFontSize
        case 31...60:
            baseSize = maxFontSize * 0.85
        case 61...100:
            baseSize = maxFontSize * 0.7
        default:
            baseSize = maxFontSize * 0.6
        }
        
        // Adjust font size if the text contains emojis.
        let emojiAdjustment: CGFloat = text.containsEmoji ? -2.0 : 0.0
        
        // Ensure the calculated size is within the allowed range.
        return max(minFontSize, min(maxFontSize, baseSize + emojiAdjustment))
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
            lineSpacing: 6,
            letterSpacing: 0.8,
            allowsTightening: true,
            maxFontSize: 32,
            minFontSize: 16,
            optimalFontSizeRange: 16...32,
            emojiScale: 0.9  // Emojis are scaled slightly smaller than text.
        )
    }
}
