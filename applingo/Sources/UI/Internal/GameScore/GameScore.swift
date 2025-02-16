import SwiftUI

struct ScoreHistoryItem: Identifiable, Equatable {
    let id = UUID()
    let score: GameScoringScoreAnswerModel
    var opacity: Double
    var offset: CGFloat
    var scale: CGFloat // Добавляем масштаб для более интересной анимации
    
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
    
    // Константы для анимации
    private enum AnimationConstants {
        static let maxItems = 3
        static let fadeRatio = 0.7
        static let offsetStep: CGFloat = 12
        static let scaleRatio: CGFloat = 0.9
        static let baseAnimationDuration = 0.2
        static let displayDuration = 0.7
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
        
        scheduleHistoryCleanup()
    }
    
    private func scheduleHistoryCleanup() {
        let workItem = DispatchWorkItem {
            withAnimation(.easeInOut(duration: AnimationConstants.baseAnimationDuration)) {
                scoreHistory.removeAll()
            }
        }
        hideScoreWorkItem = workItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + AnimationConstants.displayDuration,
            execute: workItem
        )
    }
}

// Выделяем текст очков в отдельный компонент
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
                    removal: .scale(scale: 0.9)
                        .combined(with: .opacity)
                        .animation(.easeOut(duration: 0.2))
                )
            )
    }
}
