import SwiftUI

/// A view that displays the quiz question card with a dynamic patterned background and border.
///
/// This view renders the quiz question text using the provided style and localization.
/// The question is centered, padded, and displayed on a card with adaptive dimensions.
/// The background of the card is enhanced with an animated dynamic pattern overlay,
/// and the border is rendered with a dynamic pattern.
///
/// - Environment:
///   - `themeManager`: Provides the current theme settings.
/// - Properties:
///   - `locale`: A `GameQuizLocale` object supplying localized strings.
///   - `style`: A `GameQuizStyle` object defining visual appearance and dynamic pattern details.
///   - `question`: The quiz question text to display.
struct GameQuizViewQuestion: View {
    // MARK: - Environment and Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let question: String
    
    // MARK: - Computed Properties
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * Constants.widthRatio
    }
    
    private var cardHeight: CGFloat {
        min(UIScreen.main.bounds.height * Constants.heightRatio, Constants.maxHeight)
    }
    
    // MARK: - Initializer
    /// Initializes a new instance of `GameQuizViewQuestion`.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object that defines visual appearance.
    ///   - question: The quiz question text to be displayed.
    init(locale: GameQuizLocale, style: GameQuizStyle, question: String) {
        self.locale = locale
        self.style = style
        self.question = question
    }
    
    private var questionText: some View {
            GeometryReader { geometry in
                Text(question)
                    .font(style.questionFont)
                    .foregroundColor(style.questionTextColor)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5) // Позволяет уменьшить текст до 50% от исходного размера
                    .lineLimit(4) // Максимум 4 строки
                    .lineSpacing(8) // Добавляем отступ между строками для лучшей читаемости
                    .allowsTightening(true) // Разрешаем сжатие символов
                    .frame(
                        maxWidth: geometry.size.width * 0.9, // Небольшой отступ от краев
                        maxHeight: geometry.size.height * 0.9,
                        alignment: .center
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
            }
        }
    
    // MARK: - Body
    var body: some View {
        questionText
                    .padding(style.cardPadding)
                    .frame(width: cardWidth, height: cardHeight)
                    .background(backgroundView)
                    .cornerRadius(style.cardCornerRadius)
                    .overlay(borderView)
                    .shadow(
                        //color: style.cardShadowColor.opacity(Constants.shadowOpacity),
                        radius: style.cardShadowRadius,
                        x: Constants.shadowOffset.x,
                        y: Constants.shadowOffset.y
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.9).combined(with: .opacity),
                        removal: .scale(scale: 1.1).combined(with: .opacity)
                    ))
    }
    
    // MARK: - Background View
    private var backgroundView: some View {
        ZStack {
            style.cardBackground
            PatternedBackground(style: style)
        }
    }
    
    // MARK: - Border View
    private var borderView: some View {
        PatternedBorder(style: style)
    }
}

// MARK: - Background Pattern Component
private struct PatternedBackground: View {
    let style: GameQuizStyle
    
    var body: some View {
        GeometryReader { geometry in
            let size = CGSize(
                width: geometry.size.width * Constants.patternScale,
                height: geometry.size.height * Constants.patternScale
            )
            
            DynamicPatternViewBackgroundAnimated(
                model: style.pattern,
                size: CGSize(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1),
                cornerRadius: style.cardCornerRadius,
                minScale: Constants.patternMinScale,
                opacity: Constants.patternOpacity,
                animationDuration: Constants.patternAnimationDuration
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
}

// MARK: - Border Pattern Component
private struct PatternedBorder: View {
    let style: GameQuizStyle
    
    var body: some View {
        GeometryReader { geometry in
            let size = CGSize(
                width: geometry.size.width * Constants.patternScale,
                height: geometry.size.height * Constants.patternScale
            )
            
            DynamicPatternViewBorderAnimated(
                model: style.pattern,
                size: CGSize(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1),
                cornerRadius: style.cardCornerRadius,
                minScale: Constants.patternMinScale,
                animationDuration: Constants.patternAnimationDuration,
                borderWidth: Constants.borderWidth
            )
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
        }
    }
}


// MARK: - Constants
private enum Constants {
    // Card Dimensions
    static let widthRatio: CGFloat = 0.9
    static let heightRatio: CGFloat = 0.25
    static let maxHeight: CGFloat = 250
    
    // Pattern Properties
    static let patternScale: CGFloat = 2.0
    static let patternOpacity: CGFloat = 0.2
    static let patternMinScale: CGFloat = 0.95
    static let patternAnimationDuration: Double = 4.0
    
    // Border Properties
    static let borderWidth: CGFloat = 8
    
    // Shadow Properties
    static let shadowOpacity: CGFloat = 0.15
    static let shadowOffset = CGPoint(x: 0, y: 2)
    
    // Text Properties
        static let minScaleFactor: CGFloat = 0.5
        static let maxLines: Int = 4
        static let lineSpacing: CGFloat = 8
        static let textWidthRatio: CGFloat = 0.9
        static let textHeightRatio: CGFloat = 0.9
}

