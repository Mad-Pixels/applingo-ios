import SwiftUI

struct GameScore: View {
    @ObservedObject var stats: GameStats
    @StateObject private var style: GameScoreStyle
    @State private var showScore: Bool = false
    @State private var hideScoreWorkItem: DispatchWorkItem? = nil

    init(stats: GameStats, style: GameScoreStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        self.stats = stats
    }

    var body: some View {
        // Создаем контейнер фиксированного размера
        VStack {
            if showScore {
                VStack {
                    ButtonNav(
                        style: .custom(
                            ThemeManager.shared.currentThemeStyle,
                            assetName: stats.score.type.iconName
                        ),
                        onTap: {},
                        isPressed: .constant(false)
                    )
                    Text("\(stats.score.sign)\(abs(stats.score.value))")
                        .font(style.font)
                        .foregroundColor(style.textColor)
                }
                .transition(.opacity)
                .padding(.top, 28)
            }
        }
        .frame(width: 25, height: 80) // Фиксированный размер контейнера
        .animation(.easeInOut(duration: 0.3), value: showScore)
        .onChange(of: stats.score) { newScore in
            hideScoreWorkItem?.cancel()
            
            withAnimation(.easeIn(duration: 0.3)) {
                showScore = true
            }
            
            let workItem = DispatchWorkItem {
                withAnimation(.easeOut(duration: 0.3)) {
                    showScore = false
                }
            }
            hideScoreWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 100.0, execute: workItem)
        }
    }
}
