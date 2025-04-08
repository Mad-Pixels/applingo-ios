import SwiftUI

struct GameSpecialBoardPulsingCirclesStyle {
    let circleColors: [Color]
    let circleCount: Int
    let lineWidth: CGFloat
    let minScale: CGFloat
    let maxScale: CGFloat
    let maxOpacity: Double
    let animationDuration: Double
    let delayBetweenCircles: Double
}

extension GameSpecialBoardPulsingCirclesStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardPulsingCirclesStyle {
        GameSpecialBoardPulsingCirclesStyle(
            circleColors: [.red, .orange, .yellow, .green, .blue, .purple],
            circleCount: 12,
            lineWidth: 3,
            minScale: 0.3,
            maxScale: 2.0,
            maxOpacity: 0.8,
            animationDuration: 3.0,
            delayBetweenCircles: 0.15
        )
    }
    
    static func colors(_ theme: AppTheme, colors: [Color]) -> GameSpecialBoardPulsingCirclesStyle {
        GameSpecialBoardPulsingCirclesStyle(
            circleColors: colors,
            circleCount: 12,
            lineWidth: 3,
            minScale: 0.3,
            maxScale: 2.0,
            maxOpacity: 0.8,
            animationDuration: 3.0,
            delayBetweenCircles: 0.15
        )
    }
}
