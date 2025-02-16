import SwiftUI

/// A view that displays the quiz question card with a dynamic patterned border.
///
/// This view renders the quiz question text using the provided style and localization.
/// The question is centered, padded, and displayed on a background with rounded corners.
/// The border of the card is rendered with a dynamic pattern (with a fixed border width of 8)
/// and the card itself has fixed dimensions defined by constants.
/// This component is designed for use in the GameQuiz interface.
///
/// - Environment:
///   - `themeManager`: Provides the current theme settings.
/// - Properties:
///   - `locale`: A `GameQuizLocale` object supplying localized strings.
///   - `style`: A `GameQuizStyle` object defining visual appearance and animation parameters.
///   - `question`: The quiz question text to display.
struct GameQuizViewQuestion: View {
    // MARK: - Environment and Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let question: String
    
    // Fixed dimensions for the question card
    private let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    private let cardHeight: CGFloat = 200
    
    // MARK: - Initializer
    /// Initializes a new instance of `GameQuizViewQuestion`.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object that defines visual appearance, including the dynamic border pattern.
    ///   - question: The quiz question text to be displayed.
    init(locale: GameQuizLocale, style: GameQuizStyle, question: String) {
        self.locale = locale
        self.style = style
        self.question = question
    }
    
    // MARK: - Body
    var body: some View {
        Text(question)
            .font(style.questionFont)
            .foregroundColor(style.questionTextColor)
            .multilineTextAlignment(.center)
            .padding(style.cardPadding)
            .frame(width: cardWidth, height: cardHeight)
            .background(style.cardBackground)
            .cornerRadius(style.cardCornerRadius)
            .overlay(
                Group {
                    // Use a dynamic pattern for the border with a fixed border width of 8.
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: style.cardCornerRadius)
                            .strokeBorder(Color.clear, lineWidth: 8)
                            .background(
                                DynamicPattern(
                                    model: style.pattern,
                                    size: CGSize(width: geometry.size.width * 2,
                                                 height: geometry.size.height * 2)
                                )
                            )
                            .mask(
                                RoundedRectangle(cornerRadius: style.cardCornerRadius)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 8))
                            )
                    }
                }
            )
            .shadow(radius: style.cardShadowRadius)
    }
}
