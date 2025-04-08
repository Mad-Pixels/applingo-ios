import SwiftUI

struct GameSpecialBoardStarLinesStyle {
    let lineColors: [Color]
    let lineCount: Int
    let phaseGroups: Int
    let lineWidth: CGFloat
    let minScale: CGFloat
    let maxScale: CGFloat
    let maxOpacity: Double
    let animationDuration: Double
    let delayBetweenLines: Double
}

extension GameSpecialBoardStarLinesStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardStarLinesStyle {
        GameSpecialBoardStarLinesStyle(
            lineColors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
            lineCount: 36,
            phaseGroups: 6,
            lineWidth: 2.5,
            minScale: 0.1,
            maxScale: 1.5,
            maxOpacity: 0.8,
            animationDuration: 2.0,
            delayBetweenLines: 0.1
        )
    }
    
    static func colors(_ theme: AppTheme, colors: [Color]) -> GameSpecialBoardStarLinesStyle {
        GameSpecialBoardStarLinesStyle(
            lineColors: colors,
            lineCount: 36,
            phaseGroups: 6,
            lineWidth: 2.5,
            minScale: 0.1,
            maxScale: 1.5,
            maxOpacity: 0.8,
            animationDuration: 2.0,
            delayBetweenLines: 0.1
        )
    }
}
