import SwiftUI

/// A style configuration for the DynamicText component, defining its appearance and dynamic font sizing behavior.
/// It includes properties for colors, fonts, text alignment, spacing, and emoji handling.
struct DynamicTextStyle {
    // MARK: - Appearance Properties
    let textColor: Color
    let alignment: TextAlignment
    let letterSpacing: CGFloat
    let allowsTightening: Bool
    
    // MARK: - Font Size Properties
    let maxFontSize: CGFloat
    let minFontSize: CGFloat
    
    // MARK: - Text Breaking Properties
    let lineBreakMode: NSLineBreakMode
    let wordWrapping: Bool
    
    //
    let lineLimit: Int
    let fontWeight: Font.Weight
    
    // MARK: - Dynamic Font Sizing
    func calculateOptimalFontSize(for text: String) -> CGFloat {
        let complexity = text.complexityScore

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
        
        // Корректировка на эмодзи оставляем (если требуется)
        let emojiAdjustment: CGFloat = text.containsEmoji ? -2.0 : 0.0
        let adjustedSize = baseSize + emojiAdjustment
        
        return max(minFontSize, min(maxFontSize, adjustedSize))
    }
}

// MARK: - Convenience Initializer
extension DynamicTextStyle {
    static func themed(_ theme: AppTheme) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: .center,
            letterSpacing: 0.5,
            allowsTightening: true,
            maxFontSize: 14,
            minFontSize: 14,
            lineBreakMode: .byWordWrapping,
            wordWrapping: true,
            lineLimit: 1,
            fontWeight: .regular
        )
    }
    static func action(_ theme: AppTheme) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textContrast,
            alignment: .center,
            letterSpacing: 0.3,
            allowsTightening: true,
            maxFontSize: 16,
            minFontSize: 16,
            lineBreakMode: .byWordWrapping,
            wordWrapping: false,
            lineLimit: 1,
            fontWeight: .bold
        )
    }
    static func titled(_ theme: AppTheme) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: .center,
            letterSpacing: 0.5,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 16,
            lineBreakMode: .byWordWrapping,
            wordWrapping: false,
            lineLimit: 1,
            fontWeight: .bold
        )
    }
    static func gameQuestion(_ theme: AppTheme) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: .center,
            letterSpacing: 0.8,
            allowsTightening: true,
            maxFontSize: 32,
            minFontSize: 14,
            lineBreakMode: .byWordWrapping,
            wordWrapping: true,
            lineLimit: 4,
            fontWeight: .bold
        )
    }
    static func gameAnswer(_ theme: AppTheme) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: .center,
            letterSpacing: 0.5,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 12,
            lineBreakMode: .byWordWrapping,
            wordWrapping: true,
            lineLimit: 2,
            fontWeight: .regular
        )
    }
}
