import SwiftUI

/// A view that displays a single score entry with animated transitions.
///
/// This view renders the score value from a history item using visual properties
/// (such as font, color, opacity, offset, and scale) provided by a `GameScoreStyle` object.
/// It uses asymmetric transitions for insertion and removal, providing a smooth animated effect.
/// The text color is determined by whether the score is positive or negative.
struct GameScoreViewText: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let style: GameScoreStyle
    private let item: ScoreHistoryModel
    
    // MARK: - Initializer
    /// Initializes a new instance of `GameScoreViewText`.
    ///
    /// - Parameters:
    ///   - style: A `GameScoreStyle` object that defines the visual style and animation parameters.
    ///   - item: A `ScoreHistoryModel` containing the score value and its current animation properties.
    init(
        style: GameScoreStyle,
        item: ScoreHistoryModel
    ) {
        self.style = style
        self.item = item
    }
    
    // MARK: - Body
    var body: some View {
        Text("\(item.score.sign)\(abs(item.score.value))")
            .font(style.font)
            .foregroundColor(item.score.isPositive ? style.positiveTextColor : style.negativeTextColor)
            .opacity(item.opacity)
            .offset(y: item.offset)
            .scaleEffect(item.scale)
            .transition(
                .asymmetric(
                    insertion: .scale(scale: 1.1)
                        .combined(with: .opacity)
                        .animation(.spring(response: style.baseAnimationDuration, dampingFraction: 0.7)),
                    removal: .scale(scale: 0.7)
                        .combined(with: .opacity)
                        .animation(.easeInOut(duration: style.removalDuration))
                )
            )
    }
}
