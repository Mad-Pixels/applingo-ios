import SwiftUI

struct GameSwipeChoice: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let dragOffset: CGSize
    
    private let locale: GameSwipeLocale
    private let style: GameSwipeStyle
    
    init(
        locale: GameSwipeLocale,
        style: GameSwipeStyle,
        offset: CGSize
    ) {
        self.dragOffset = offset
        self.locale = locale
        self.style = style
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                if dragOffset.width < -20 {
                    DynamicText(
                        model: DynamicTextModel(text: makeVertical(locale.screenCardWrong).uppercased()),
                        style: .headerGame(
                            themeManager.currentThemeStyle,
                            alignment: .center,
                            lineLimit: 20
                        )
                    )
                    .animation(.easeInOut, value: dragOffset.width)
                    .glassBackground(cornerRadius: 12, opacity: 0.85)
                    .frame(maxWidth: 60, maxHeight: .infinity)
                    .zIndex(10)
                } else {
                    Spacer().frame(width: 60)
                }

                Spacer()

                if dragOffset.width > 20 {
                    DynamicText(
                        model: DynamicTextModel(text: makeVertical(locale.screenCardRight).uppercased()),
                        style: .headerGame(
                            themeManager.currentThemeStyle,
                            alignment: .center,
                            lineLimit: 20
                        )
                    )
                    .animation(.easeInOut, value: dragOffset.width)
                    .glassBackground(cornerRadius: 12, opacity: 0.85)
                    .frame(maxWidth: 60, maxHeight: .infinity)
                    .zIndex(10)
                    
                } else {
                    Spacer().frame(width: 60)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }

    private var maxOffset: CGFloat {
        150
    }

    private var textOpacity: Double {
        let distance = abs(dragOffset.width)
        return min(0.5, Double(distance / maxOffset))
    }

    private func makeVertical(_ text: String) -> String {
        text.map { String($0) }.joined(separator: "\n")
    }
}
