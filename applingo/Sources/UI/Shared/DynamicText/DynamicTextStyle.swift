import SwiftUI

struct DynamicTextStyle {
    let textColor: Color
    let baseFont: Font
    let alignment: TextAlignment
    let lineSpacing: CGFloat
    let letterSpacing: CGFloat
    let allowsTightening: Bool
    
    // Размеры шрифта
    let maxFontSize: CGFloat
    let minFontSize: CGFloat
    let optimalFontSizeRange: ClosedRange<CGFloat>
    
    // Настройки для эмодзи
    let emojiScale: CGFloat
    
    // Вычисляем оптимальный размер шрифта на основе текста
    func calculateOptimalFontSize(for text: String) -> CGFloat {
        let complexity = text.complexityScore
        
        // Базовый размер на основе сложности
        let baseSize: CGFloat
        switch complexity {
        case 0...30:   baseSize = maxFontSize
        case 31...60:  baseSize = maxFontSize * 0.85
        case 61...100: baseSize = maxFontSize * 0.7
        default:       baseSize = maxFontSize * 0.6
        }
        
        // Корректируем размер, если есть эмодзи
        let emojiAdjustment = text.containsEmoji ? -2.0 : 0.0
        
        // Обеспечиваем, что результат находится в допустимом диапазоне
        return max(minFontSize, min(maxFontSize, baseSize + emojiAdjustment))
    }
}

extension DynamicTextStyle {
    static func gameMain(_ theme: AppTheme) -> DynamicTextStyle {
        DynamicTextStyle(
            textColor: theme.textPrimary,
            baseFont: .system(size: 32, weight: .bold),
            alignment: .center,
            lineSpacing: 6,
            letterSpacing: 0.8,
            allowsTightening: true,
            maxFontSize: 32,
            minFontSize: 16,
            optimalFontSizeRange: 16...32,
            emojiScale: 0.9  // Эмодзи чуть меньше текста
        )
    }
}
