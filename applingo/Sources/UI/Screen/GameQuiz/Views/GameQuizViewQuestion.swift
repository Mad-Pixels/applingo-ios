import SwiftUI

/// A view that displays the quiz question card with a dynamic patterned background and border.
///
/// This view renders the quiz question text using the provided style and localization.
/// The question is centered, padded, and displayed on a card with fixed dimensions.
/// The background of the card is enhanced with a dynamic pattern overlay at 85% opacity,
/// and the border is rendered with a dynamic pattern with a fixed width of 8.
/// This component is designed for use in the GameQuiz interface.
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
    
    // Fixed dimensions for the question card
    private let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.9
    private let cardHeight: CGFloat = 200
    
    // MARK: - Initializer
    /// Initializes a new instance of `GameQuizViewQuestion`.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object that defines visual appearance, including dynamic pattern details.
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
            .background(
                ZStack {
                    // Base background color.
                    style.cardBackground
                    // Dynamic patterned background with 85% opacity.
                    GeometryReader { geometry in
                        DynamicPattern(
                            model: style.pattern,
                            size: CGSize(width: geometry.size.width * 2,
                                         height: geometry.size.height * 2)
                        )
                        .opacity(0.2)
                        .mask(
                            RoundedRectangle(cornerRadius: style.cardCornerRadius)
                        )
                    }
                }
            )
            .cornerRadius(style.cardCornerRadius)
            .overlay(
                Group {
                    // Dynamic patterned border with fixed border width of 8.
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
