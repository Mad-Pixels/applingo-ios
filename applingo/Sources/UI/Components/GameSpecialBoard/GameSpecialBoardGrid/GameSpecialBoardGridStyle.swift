import SwiftUI

struct GameSpecialBoardGridStyle {
    let gridColors: [Color]
    let gridOpacity: Double
    let gridSpacing: CGFloat
    let minDotSize: CGFloat
    let maxDotSize: CGFloat
    let phaseCount: Int
    let animationDuration: Double
    let animationDelayStep: Double
}

extension GameSpecialBoardGridStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardGridStyle {
        GameSpecialBoardGridStyle(
            gridColors: [.green, .mint, .teal],
            gridOpacity: 0.4,
            gridSpacing: 40,
            minDotSize: 2,
            maxDotSize: 15,
            phaseCount: 6,
            animationDuration: 2.5,
            animationDelayStep: 0.15
        )
    }
    
    static func colors(_ theme: AppTheme, colors: [Color]) -> GameSpecialBoardGridStyle {
        GameSpecialBoardGridStyle(
            gridColors: colors,
            gridOpacity: 0.4,
            gridSpacing: 40,
            minDotSize: 2,
            maxDotSize: 15,
            phaseCount: 6,
            animationDuration: 2.5,
            animationDelayStep: 0.15
        )
    }
}
