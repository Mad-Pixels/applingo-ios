import SwiftUI

/// Компонент GameText отображает переданный текст согласно заданному стилю.
/// Основные возможности:
/// - Правильное позиционирование и выравнивание текста.
/// - Динамическое масштабирование шрифта с помощью minimumScaleFactor.
/// - Управление переносом строк и интерлиньяжем.
/// - Анимация при изменении текста.
struct DynamicText: View {
    let model: DynamicTextModel
    let style: DynamicTextStyle
    
    private var optimalFontSize: CGFloat {
        style.calculateOptimalFontSize(for: model.text)
    }
    
    private var attributedText: AttributedString {
        var attributed = AttributedString(model.text)
        
        // Применяем базовые атрибуты для всего текста
        attributed.font = .system(size: optimalFontSize, weight: .bold)
        attributed.foregroundColor = style.textColor
        
        // Находим и обрабатываем эмодзи
        let runs = attributed.runs
        for run in runs {
            let range = run.range
            let text = String(attributed[range].characters)
            if text.unicodeScalars.contains(where: { $0.properties.isEmoji }) {
                attributed[range].font = .system(size: optimalFontSize * style.emojiScale)
            }
        }
        
        return attributed
    }
    
    var body: some View {
        Text(attributedText)
            .multilineTextAlignment(style.alignment)
            .lineSpacing(style.lineSpacing)
            .tracking(style.letterSpacing)
            .allowsTightening(style.allowsTightening)
            .minimumScaleFactor(style.minFontSize / optimalFontSize)
            .fixedSize(horizontal: false, vertical: true)
            .animation(
                .spring(response: 0.3, dampingFraction: 0.7),
                value: model.text
            )
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 8)
    }
}
