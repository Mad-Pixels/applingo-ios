import SwiftUI

internal struct GameQuizViewQuestion: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let card: QuizModelCard
    
    /// Initializes the GameQuizViewQuestion.
    /// - Parameters:
    ///   - locale: The localization object for the quiz view.
    ///   - style: The style object that defines the visual appearance.
    ///   - card: The `QuizModelCard`'.
    init(locale: GameQuizLocale, style: GameQuizStyle, card: QuizModelCard) {
        self.card = card
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        if !card.voice {
            GameQuizViewQuestionText(question: card.question, style: style)
                .padding(style.cardPadding)
                .frame(width: cardWidth, height: cardHeight)
                .background(style.cardBackground)
                .animatedBackground(
                    model: style.pattern,
                    size: CGSize(width: cardWidth * 1.1, height: cardHeight * 1.1),
                    cornerRadius: style.cardCornerRadius,
                    minScale: style.patternMinScale,
                    opacity: style.patternOpacity,
                    animationDuration: style.patternAnimationDuration
                )
                .cornerRadius(style.cardCornerRadius)
                .animatedBorder(
                    model: style.pattern,
                    size: CGSize(width: cardWidth * 1.1, height: cardHeight * 1.1),
                    cornerRadius: style.cardCornerRadius,
                    minScale: style.patternMinScale,
                    animationDuration: style.patternAnimationDuration,
                    borderWidth: style.borderWidth
                )
                .shadow(
                    radius: style.cardShadowRadius,
                    x: style.shadowOffset.x,
                    y: style.shadowOffset.y
                )
        } else {
            GameQuizViewQuestionSpeak(word: card.word)
                .padding(style.cardPadding)
                .frame(width: cardWidth, height: cardHeight)
                .background(style.cardBackground)
                .animatedBackground(
                    model: style.pattern,
                    size: CGSize(width: cardWidth * 1.1, height: cardHeight * 1.1),
                    cornerRadius: style.cardCornerRadius,
                    minScale: style.patternMinScale,
                    opacity: style.patternOpacity,
                    animationDuration: style.patternAnimationDuration
                )
                .cornerRadius(style.cardCornerRadius)
                .animatedBorder(
                    model: style.pattern,
                    size: CGSize(width: cardWidth * 1.1, height: cardHeight * 1.1),
                    cornerRadius: style.cardCornerRadius,
                    minScale: style.patternMinScale,
                    animationDuration: style.patternAnimationDuration,
                    borderWidth: style.borderWidth
                )
                .shadow(
                    radius: style.cardShadowRadius,
                    x: style.shadowOffset.x,
                    y: style.shadowOffset.y
                )
        }
    }
    
    /// The card's width, calculated based on the screen width and the style's width ratio.
    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * style.widthRatio
    }
    
    /// The card's height, limited by the screen height and the style's maximum height.
    private var cardHeight: CGFloat {
        min(UIScreen.main.bounds.height * style.heightRatio, style.maxHeight)
    }
}
