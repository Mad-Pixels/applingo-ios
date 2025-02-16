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
        Group {
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
        .animation(.easeInOut(duration: 0.3), value: showScore)
        .onChange(of: stats.score) { newScore in
            // Отменяем предыдущий таймер, если он есть
            hideScoreWorkItem?.cancel()
            
            // Плавно показываем представление
            withAnimation(.easeIn(duration: 0.3)) {
                showScore = true
            }
            
            // Создаём новый DispatchWorkItem для скрытия представления через 1 секунду
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
