import SwiftUI

struct DynamicTextStyle {
    // Appearance Properties
    let textColor: Color
    let alignment: TextAlignment
    let letterSpacing: CGFloat
    let allowsTightening: Bool
    
    // Font Size Properties
    let maxFontSize: CGFloat
    let minFontSize: CGFloat
    
    // Text Wrapping Properties
    let lineBreakMode: NSLineBreakMode
    let wordWrapping: Bool
    
    // Additional Properties
    let lineLimit: Int
    let fontWeight: Font.Weight
    
    // Font Design Property
    let fontDesign: Font.Design
    
    // Dynamic Font Size Calculation
    /// Calculates the optimal font size for the given text based on its complexity.
    /// Complexity is determined by factors like text length, word count, emoji count, uppercase ratio, and punctuation count.
    func calculateOptimalFontSize(for text: String) -> CGFloat {
        let complexity = text.complexityScore

        let baseSize = maxFontSize * (1.0 - (min(complexity, 100) / 100) * 0.3)
        let emojiAdjustment: CGFloat = text.containsEmoji ? -2.0 : 0.0
        return max(minFontSize, min(maxFontSize, baseSize + emojiAdjustment))
    }
}

extension DynamicTextStyle {
    static func textMain(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1,
        color: Color = ThemeManager.shared.currentThemeStyle.textPrimary
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: color,
            alignment: alignment,
            letterSpacing: 0.2,
            allowsTightening: true,
            maxFontSize: 16,
            minFontSize: 12,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .regular,
            fontDesign: .default
        )
    }
    
    static func textBold(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: alignment,
            letterSpacing: 0.2,
            allowsTightening: true,
            maxFontSize: 16,
            minFontSize: 14,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .bold,
            fontDesign: .default
        )
    }
    
    static func textLight(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: alignment,
            letterSpacing: 0.2,
            allowsTightening: true,
            maxFontSize: 16,
            minFontSize: 14,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .light,
            fontDesign: .default
        )
    }
    
    static func textGame(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: alignment,
            letterSpacing: 0.2,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 10,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .medium,
            fontDesign: .default
        )
    }
    
    static func textGameCompact(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: alignment,
            letterSpacing: 0.0,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 8,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .medium,
            fontDesign: .default
        )
    }
    
    static func textGameBold(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1,
        fontColor: Color? = nil
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        let color = fontColor ?? theme.textPrimary
        
        return DynamicTextStyle(
            textColor: color,
            alignment: alignment,
            letterSpacing: 0.2,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 10,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .heavy,
            fontDesign: .rounded
        )
    }
    
    static func headerMain(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1,
        fontColor: Color? = nil
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        let color = fontColor ?? theme.textPrimary
        
        return DynamicTextStyle(
            textColor: color,
            alignment: alignment,
            letterSpacing: 0.4,
            allowsTightening: true,
            maxFontSize: 26,
            minFontSize: 20,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .bold,
            fontDesign: .rounded
        )
    }
    
    static func headerHuge(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1,
        fontColor: Color? = nil
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        let color = fontColor ?? theme.textPrimary
        
        return DynamicTextStyle(
            textColor: color,
            alignment: alignment,
            letterSpacing: 0.4,
            allowsTightening: true,
            maxFontSize: 42,
            minFontSize: 36,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .bold,
            fontDesign: .rounded
        )
    }
    
    static func headerBlock(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.accentPrimary,
            alignment: alignment,
            letterSpacing: 0.2,
            allowsTightening: true,
            maxFontSize: 16,
            minFontSize: 14,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .bold,
            fontDesign: .rounded
        )
    }
    
    static func headerGame(
        _ theme: AppTheme,
        alignment: TextAlignment = .leading,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: alignment,
            letterSpacing: 0.6,
            allowsTightening: true,
            maxFontSize: 32,
            minFontSize: 12,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .bold,
            fontDesign: .rounded
        )
    }
    
    static func button(
        _ theme: AppTheme,
        alignment: TextAlignment = .center,
        lineLimit: Int = 1
    ) -> DynamicTextStyle {
        let shouldWrapWords = lineLimit > 1
        
        return DynamicTextStyle(
            textColor: theme.textContrast,
            alignment: alignment,
            letterSpacing: 0.3,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 16,
            lineBreakMode: shouldWrapWords ? .byWordWrapping : .byTruncatingTail,
            wordWrapping: shouldWrapWords,
            lineLimit: lineLimit,
            fontWeight: .medium,
            fontDesign: .default
        )
    }
    
    static func picker(
        _ theme: AppTheme,
        fontSize: CGFloat = 14
    ) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: theme.textPrimary,
            alignment: .center,
            letterSpacing: 0.0,
            allowsTightening: true,
            maxFontSize: fontSize,
            minFontSize: fontSize - 2,
            lineBreakMode: .byTruncatingTail,
            wordWrapping: false,
            lineLimit: 1,
            fontWeight: .medium,
            fontDesign: .default
        )
    }
    
    static func gameScore(
        _ theme: AppTheme,
        isPositive: Bool
    ) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: isPositive ? theme.success : theme.error,
            alignment: .center,
            letterSpacing: 0.0,
            allowsTightening: true,
            maxFontSize: 16,
            minFontSize: 10,
            lineBreakMode: .byTruncatingTail,
            wordWrapping: false,
            lineLimit: 1,
            fontWeight: .bold,
            fontDesign: .default
        )
    }
    
    static func gameTab(
        _ theme: AppTheme,
        color: Color
    ) -> DynamicTextStyle {
        return DynamicTextStyle(
            textColor: color,
            alignment: .center,
            letterSpacing: 0.0,
            allowsTightening: true,
            maxFontSize: 18,
            minFontSize: 10,
            lineBreakMode: .byTruncatingTail,
            wordWrapping: false,
            lineLimit: 1,
            fontWeight: .bold,
            fontDesign: .rounded
        )
    }
}
