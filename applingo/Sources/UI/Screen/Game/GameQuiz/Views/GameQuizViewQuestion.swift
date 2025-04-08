import SwiftUI

internal struct GameQuizViewQuestion: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let locale: GameQuizLocale
    private let style: GameQuizStyle
    private let card: QuizModelCard

    init(locale: GameQuizLocale, style: GameQuizStyle, card: QuizModelCard) {
        self.card = card
        self.locale = locale
        self.style = style
    }

    var body: some View {
        Group {
            if card.voice && !card.flip {
                GameQuizViewQuestionSpeak(word: card.word)
            } else {
                GameQuizViewQuestionText(question: card.question, style: style)
            }
        }
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

    private var cardWidth: CGFloat {
        UIScreen.main.bounds.width * style.widthRatio
    }

    private var cardHeight: CGFloat {
        min(UIScreen.main.bounds.height * style.heightRatio, style.maxHeight)
    }
}
