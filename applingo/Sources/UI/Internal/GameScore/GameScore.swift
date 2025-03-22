import SwiftUI

/// A view that displays animated game score updates.
///
/// This view observes changes in game statistics and maintains a history of score updates,
/// which are rendered with fading, offset, scaling, and varying saturation animations.
/// New score updates are inserted at the top (with full saturation) while older entries animate out over time.
/// Animation and visual style parameters are configured via a `GameScoreStyle` object.
struct GameScore: View {
    // MARK: - Properties
    @State private var hideScoreWorkItem: DispatchWorkItem? = nil
    @State private var scoreHistory: [ScoreHistoryModel] = []
    
    // MARK: - State Objects
    @StateObject private var style: GameScoreStyle
    
    // MARK: - Observed Objects
    @ObservedObject var stats: GameStats
    
    // MARK: - Initializer
    /// Initializes the GameScore view with the provided game statistics and an optional style.
    /// If no style is provided, a themed style based on the current theme is used.
    /// - Parameters:
    ///   - stats: The game statistics.
    ///   - style: An optional GameScoreStyle instance.
    init(stats: GameStats, style: GameScoreStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        self.stats = stats
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            if !scoreHistory.isEmpty {
                VStack(spacing: 4) {
                    Group {
                        Image(stats.score.type.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(height: style.iconSize)
                    
                    ZStack {
                        ForEach(Array(scoreHistory.enumerated()), id: \.element.id) { index, item in
                            let computedSaturation = max(1.0 - Double(index) * style.saturationStep, style.minSaturation)
                            GameScoreViewText(style: style, item: item, saturation: computedSaturation)
                        }
                    }
                }
                .padding(.top, 23)
            }
        }
        .frame(width: 42, height: 72, alignment: .leading)
        .onChange(of: stats.score) { newScore in
            handleNewScore(newScore)
        }
    }
    
    // MARK: - Private Methods
    /// Handles a new score update by updating the history with animation.
    /// - Parameter newScore: The newly computed score.
    private func handleNewScore(_ newScore: GameScoringScoreAnswerModel) {
        hideScoreWorkItem?.cancel()
        
        withAnimation(.spring(response: style.baseAnimationDuration, dampingFraction: 0.7)) {
            scoreHistory = scoreHistory.map { item in
                ScoreHistoryModel(
                    score: item.score,
                    opacity: item.opacity * style.fadeRatio,
                    offset: item.offset + style.offsetStep,
                    scale: item.scale * style.scaleRatio
                )
            }
            
            let newItem = ScoreHistoryModel(
                score: newScore,
                opacity: 1.0,
                offset: 0,
                scale: 1.0
            )
            scoreHistory.insert(newItem, at: 0)
            
            if scoreHistory.count > style.maxAnimationItems {
                scoreHistory.removeLast()
            }
        }
        scheduleStaggeredRemoval()
    }
    
    /// Schedules a staggered removal of score history items after a display duration.
    private func scheduleStaggeredRemoval() {
        let workItem = DispatchWorkItem {
            removeItemsSequentially()
        }
        hideScoreWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + style.displayDuration,
            execute: workItem
        )
    }
    
    /// Removes score history items sequentially with a staggered animation.
    private func removeItemsSequentially() {
        let delays = (0..<scoreHistory.count).map { index in
            Double(index) * style.removalDelay
        }.reversed()
        
        for (_, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: style.removalDuration)) {
                    if !scoreHistory.isEmpty, let lastIndex = scoreHistory.indices.last {
                        scoreHistory[lastIndex].opacity = 0
                        scoreHistory[lastIndex].scale = 0.7
                        
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + style.removalDuration
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
