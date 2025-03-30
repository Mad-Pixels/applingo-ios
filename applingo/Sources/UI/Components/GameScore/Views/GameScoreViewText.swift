import SwiftUI

internal struct GameScoreViewText: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: GameScoreStyle
    private let item: ScoreHistoryModel
    private let saturation: Double
    
    /// Initializes the GameScoreViewText.
    /// - Parameters:
    ///   - style: A `GameScoreStyle` object that defines visual style and animation parameters.
    ///   - item: A `ScoreHistoryModel` containing the score value and its current animation properties.
    ///   - saturation: A value between 0 and 1 representing the color saturation.
    init(style: GameScoreStyle, item: ScoreHistoryModel, saturation: Double) {
        self.style = style
        self.item = item
        self.saturation = saturation
    }
    
    var body: some View {
        DynamicText(
            model: DynamicTextModel(text: "\(item.score.sign)\(abs(item.score.value))"),
            style: .gameScore(
                themeManager.currentThemeStyle,
                isPositive: item.score.isPositive
            )
        )
        .saturation(saturation)
        .opacity(item.opacity)
        .offset(y: item.offset)
        .scaleEffect(item.scale)
        .blur(radius: (1 - saturation) * 0.5)
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
        .frame(width: nil, alignment: .center)
    }
}
