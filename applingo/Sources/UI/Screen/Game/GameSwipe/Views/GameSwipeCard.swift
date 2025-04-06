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
        VStack {
            HStack {
                Text("❌ Не верно")
                    .foregroundColor(.red)
                    .opacity(dragOffset.width < -20 ? 1 : 0)
                    .animation(.easeInOut, value: dragOffset.width)

                Spacer()

                Text("Верно ✅")
                    .foregroundColor(.green)
                    .opacity(dragOffset.width > 20 ? 1 : 0)
                    .animation(.easeInOut, value: dragOffset.width)
            }
            .padding(.horizontal)

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

                VStack(spacing: 1) {
                    DynamicText(
                        model: DynamicTextModel(text: card.frontText),
                        style: .headerGame(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .center,
                            lineLimit: 4
                        )
                    )
                    .padding(.bottom, style.cardTextPadding)
                    
                    Divider()
                        .background(themeManager.currentThemeStyle.accentPrimary)
                        .padding(.horizontal, 30)
                    
                    DynamicText(
                        model: DynamicTextModel(text: card.backText),
                        style: .headerMain(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .center,
                            lineLimit: 4,
                            fontColor: style.textSecondaryColor
                        )
                    )
                    .padding(.top, style.cardTextPadding)
                }
                .padding()
            }
            .frame(width: 300, height: 400)
        }
    }
}
