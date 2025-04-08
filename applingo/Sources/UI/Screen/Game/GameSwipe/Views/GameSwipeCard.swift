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
            let model = card.specialBonus?.backgroundColor ?? themeManager.currentThemeStyle.mainPattern
            let border = card.specialBonus?.borderColor ?? themeManager.currentThemeStyle.mainPattern

            GameSwipeCardBackground(
                cornerRadius: style.cornerRadius,
                model: model
            )

            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(themeManager.currentThemeStyle.backgroundPrimary.opacity(0.9))
                .shadow(radius: 5)

            GameCardSwipeBorder(
                cornerRadius: style.cornerRadius,
                model: border
            )

            if let icon = card.specialBonus?.icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(card.specialBonus?.borderColor.colors.first ?? .clear)
                    .padding(10)
                    .background(themeManager.currentThemeStyle.backgroundPrimary)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(themeManager.currentThemeStyle.backgroundSecondary, lineWidth: 2)
                    )
                    .offset(x: 145, y: -195)
            }

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

    private var maxOffset: CGFloat { 150 }

    private var cardOpacity: Double {
        let distance = abs(dragOffset.width)
        let normalized = min(1, distance / maxOffset)
        return max(0.08, pow(1 - normalized, 2.2))
    }
}
