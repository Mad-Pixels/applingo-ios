import SwiftUI

struct ScoreHistoryItem: Identifiable, Equatable {
    let id = UUID()
    let score: GameScoringScoreAnswerModel
    var opacity: Double
    var offset: CGFloat
    var scale: CGFloat
    
    static func == (lhs: ScoreHistoryItem, rhs: ScoreHistoryItem) -> Bool {
        lhs.score == rhs.score &&
        lhs.opacity == rhs.opacity &&
        lhs.offset == rhs.offset &&
        lhs.scale == rhs.scale
    }
}

struct GameScore: View {
    @ObservedObject var stats: GameStats
    @StateObject private var style: GameScoreStyle
    @State private var scoreHistory: [ScoreHistoryItem] = []
    @State private var hideScoreWorkItem: DispatchWorkItem? = nil
    
    private enum AnimationConstants {
        static let maxItems = 3
        static let fadeRatio = 0.7
        static let offsetStep: CGFloat = 12
        static let scaleRatio: CGFloat = 0.9
        static let baseAnimationDuration = 0.2
        static let displayDuration = 2.0 // Уменьшили до 2 секунд
        static let removalDuration = 0.25 // Длительность исчезновения каждого элемента
        static let removalDelay = 0.25 // Увеличили задержку между исчезновениями
    }

    init(stats: GameStats, style: GameScoreStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        self.stats = stats
    }

    var body: some View {
        VStack {
            if !scoreHistory.isEmpty {
                VStack(spacing: 4) {
                    ButtonNav(
                        style: .custom(
                            ThemeManager.shared.currentThemeStyle,
                            assetName: stats.score.type.iconName
                        ),
                        onTap: {},
                        isPressed: .constant(false)
                    )
                    
                    ZStack {
                        ForEach(scoreHistory) { item in
                            ScoreText(item: item, style: style)
                        }
                    }
                }
                .padding(.top, 26)
            }
        }
        .frame(width: 42, height: 60)
        .onChange(of: stats.score) { newScore in
            handleNewScore(newScore)
        }
    }
    
    private func handleNewScore(_ newScore: GameScoringScoreAnswerModel) {
        hideScoreWorkItem?.cancel()
        
        withAnimation(.spring(response: AnimationConstants.baseAnimationDuration,
                            dampingFraction: 0.7)) {
            // Обновляем существующие элементы
            scoreHistory = scoreHistory.map { item in
                ScoreHistoryItem(
                    score: item.score,
                    opacity: item.opacity * AnimationConstants.fadeRatio,
                    offset: item.offset + AnimationConstants.offsetStep,
                    scale: item.scale * AnimationConstants.scaleRatio
                )
            }
            
            // Добавляем новый элемент
            let newItem = ScoreHistoryItem(
                score: newScore,
                opacity: 1.0,
                offset: 0,
                scale: 1.0
            )
            scoreHistory.insert(newItem, at: 0)
            
            // Ограничиваем количество элементов
            if scoreHistory.count > AnimationConstants.maxItems {
                scoreHistory.removeLast()
            }
        }
        
        scheduleStaggeredRemoval()
    }
    
    private func scheduleStaggeredRemoval() {
        let workItem = DispatchWorkItem {
            removeItemsSequentially()
        }
        hideScoreWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + AnimationConstants.displayDuration,
            execute: workItem
        )
    }
    
    private func removeItemsSequentially() {
        // Создаем массив задержек для каждого элемента
        let delays = (0..<scoreHistory.count).map { index in
            Double(index) * AnimationConstants.removalDelay
        }.reversed()
        
        // Применяем задержки к каждому элементу
        for (index, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: AnimationConstants.removalDuration)) {
                    if !scoreHistory.isEmpty {
                        if let lastIndex = scoreHistory.indices.last {
                            scoreHistory[lastIndex].opacity = 0
                            scoreHistory[lastIndex].scale = 0.7
                            
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + AnimationConstants.removalDuration
                            ) {
                                if !scoreHistory.isEmpty {
                                    scoreHistory.removeLast()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ScoreText: View {
    let item: ScoreHistoryItem
    let style: GameScoreStyle
    
    var body: some View {
        Text("\(item.score.sign)\(abs(item.score.value))")
            .font(style.font)
            .foregroundColor(
                item.score.isPositive ?
                style.positiveTextColor : style.negativeTextColor
            )
            .opacity(item.opacity)
            .offset(y: item.offset)
            .scaleEffect(item.scale)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 1.1)
                        .combined(with: .opacity)
                        .animation(.spring(response: 0.2, dampingFraction: 0.7)),
                    removal: .scale(scale: 0.7)
                        .combined(with: .opacity)
                        .animation(.easeInOut(duration: 0.25))
                )
            )
    }
}
