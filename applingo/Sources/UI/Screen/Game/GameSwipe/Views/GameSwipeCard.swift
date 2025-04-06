import SwiftUI

struct GameSwipeCard: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let locale: GameSwipeLocale
    private let style: GameSwipeStyle
    private let card: SwipeModelCard
    private let dragOffset: CGSize

    init(
        locale: GameSwipeLocale,
        style: GameSwipeStyle,
        card: SwipeModelCard,
        offset: CGSize
    ) {
        self.dragOffset = offset
        self.locale = locale
        self.style = style
        self.card = card
    }

    var body: some View {
        ZStack {
            GameSwipeCardBackground(
                cornerRadius: style.cornerRadius,
                style: themeManager.currentThemeStyle
            )

            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(themeManager.currentThemeStyle.backgroundPrimary.opacity(0.8))
                .shadow(radius: 5)

            GameCardSwipeBorder(
                cornerRadius: style.cornerRadius,
                style: themeManager.currentThemeStyle
            )

            VStack(spacing: style.cardTextPadding) {
                DynamicText(
                    model: DynamicTextModel(text: card.frontText),
                    style: .headerGame(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 4
                    )
                )

                Divider()
                    .background(themeManager.currentThemeStyle.accentPrimary)
                    .padding(.horizontal, 30)

                DynamicText(
                    model: DynamicTextModel(text: card.backText),
                    style: .headerMain(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 4,
                        fontColor: style.textSecondaryColor
                    )
                )
            }
            .padding()
        }
        .frame(width: 300, height: 400)
        .opacity(cardOpacity)
    }
    
    private var maxOffset: CGFloat {
        150
    }

    private var cardOpacity: Double {
        let distance = abs(dragOffset.width)
        return max(0.1, Double(1 - (distance / maxOffset)))
    }
}
