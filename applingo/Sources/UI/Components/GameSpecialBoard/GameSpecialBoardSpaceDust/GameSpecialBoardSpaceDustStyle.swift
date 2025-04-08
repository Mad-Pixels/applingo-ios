import SwiftUI

struct GameSpecialBoardSpaceDustStyle {
    let starColors: [Color]
    let dustColors: [Color]
    let starCount: Int
    let minStarSize: CGFloat
    let maxStarSize: CGFloat
    let minOpacity: Double
    let maxOpacity: Double
    let animationDuration: Double
    let dustCloudCount: Int
    let dustPointsPerCloud: Int
    let dustCloudScale: CGFloat
    let dustOpacity: Double
    let dustBlur: CGFloat
    let rotationDuration: Double
    let brightStarColors: [Color]
    let brightStarCount: Int
    let brightStarMinSize: CGFloat
    let brightStarMaxSize: CGFloat
    let brightStarMinOpacity: Double
    let brightStarMaxOpacity: Double
}

extension GameSpecialBoardSpaceDustStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardSpaceDustStyle {
        GameSpecialBoardSpaceDustStyle(
            starColors: [.white, .yellow, .orange, .blue],
            dustColors: [.purple, .blue, .cyan, .indigo],
            starCount: 120,
            minStarSize: 1.5,
            maxStarSize: 4,
            minOpacity: 0.4,
            maxOpacity: 0.95,
            animationDuration: 3.0,
            dustCloudCount: 6,
            dustPointsPerCloud: 10,
            dustCloudScale: 0.9,
            dustOpacity: 0.25,
            dustBlur: 20,
            rotationDuration: 45.0,
            brightStarColors: [.white, Color(red: 0.9, green: 0.9, blue: 1.0), Color(red: 1.0, green: 0.9, blue: 0.6)],
            brightStarCount: 15,
            brightStarMinSize: 3,
            brightStarMaxSize: 6,
            brightStarMinOpacity: 0.7,
            brightStarMaxOpacity: 1.0
        )
    }
}

