import SwiftUI



// MARK: - Вспомогательная структура для оценки сложности текста
private struct TextComplexity {
    let length: Int
    let wordCount: Int
    let emojiCount: Int
    let uppercaseRatio: Double
    let punctuationCount: Int
    
    var score: Double {
        let lengthScore = Double(length) * 0.3
        let wordScore = Double(wordCount) * 0.3
        let emojiScore = Double(emojiCount) * 0.2
        let uppercaseScore = uppercaseRatio * 0.1
        let punctuationScore = Double(punctuationCount) * 0.1
        
        return lengthScore + wordScore + emojiScore + uppercaseScore + punctuationScore
    }
}

// MARK: - Кэш для размера шрифта
final class TextSizeCache {
    private static var cache: [String: CGFloat] = [:]
    private static let maxCacheSize = 100
    
    static func getCachedSize(for text: String) -> CGFloat? {
        return cache[text]
    }
    
    static func cacheSize(_ size: CGFloat, for text: String) {
        if cache.count >= maxCacheSize {
            cache.removeAll() // Можно реализовать удаление самых старых записей
        }
        cache[text] = size
    }
}

// MARK: - Вычисление толщины шрифта
private func calculateFontWeight(for text: String) -> Font.Weight {
    switch text.count {
    case 0...20:   return .bold       // Короткий текст — жирный
    case 21...50:  return .semibold   // Средний текст — полужирный
    case 51...100: return .medium     // Длинный текст — средний
    default:       return .regular    // Очень длинный текст — обычный
    }
}

/// Компонент DynamicText отображает переданный текст согласно заданному стилю.
/// Основные возможности:
/// - Правильное позиционирование и выравнивание текста.
/// - Динамическое масштабирование шрифта с помощью minimumScaleFactor.
/// - Управление переносом строк и интерлиньяжем.
/// - Анимация при изменении текста.
struct DynamicText: View {
    let model: DynamicTextModel
    let style: DynamicTextStyle
    
    /// Вычисляем оптимальный размер шрифта, используя кэш.
    private var optimalFontSize: CGFloat {
        if let cached = TextSizeCache.getCachedSize(for: model.text) {
            return cached
        }
        
        // Передаём исходный текст в функцию вычисления оптимального размера
        let size = style.calculateOptimalFontSize(for: model.text)
        TextSizeCache.cacheSize(size, for: model.text)
        return size
    }
    
    /// Формируем атрибутированный текст с рассчитанным размером и толщиной шрифта.
    private var attributedText: AttributedString {
        var attributed = AttributedString(model.text)
        attributed.font = .system(
            size: optimalFontSize,
            weight: calculateFontWeight(for: model.text)
        )
        attributed.foregroundColor = style.textColor
        return attributed
    }
    
    var body: some View {
        Text(attributedText)
            .multilineTextAlignment(style.alignment)
            .tracking(style.letterSpacing)
            .allowsTightening(style.allowsTightening)
            // Вычисляем коэффициент масштабирования: minFontSize / оптимальный размер
            .minimumScaleFactor(style.minFontSize / optimalFontSize)
            .fixedSize(horizontal: false, vertical: true)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: model.text)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 8)
    }
}
