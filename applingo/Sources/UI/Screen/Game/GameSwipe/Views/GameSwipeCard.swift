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
            // ✅ Используем визуализацию из бонуса
            if let bonus = card.specialBonus {
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(bonus.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(bonus.borderColor, lineWidth: 3)
                    )
                    .shadow(radius: 5)

                if let icon = bonus.icon {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(bonus.borderColor)
                        .padding(10)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .offset(x: 120, y: -150)
                }
            } else {
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
    
    private var maxOffset: CGFloat {
        150
    }

    private var cardOpacity: Double {
        let distance = abs(dragOffset.width)
        let normalized = min(1, distance / maxOffset)
        return max(0.08, pow(1 - normalized, 2.2))
    }
}
