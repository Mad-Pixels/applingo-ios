import SwiftUI

struct GameSpecialBoardNebulaStyle {
    let nebulaColors: [Color]
    let nebulaCount: Int
    let blobPointCount: Int
    let blobIrregularity: CGFloat
    let blobSizeMultiplier: CGFloat
    let blobOpacity: Double
    let blobBlurRadius: CGFloat
    let blobAnimationDuration: Double
    
    let dustColors: [Color]
    let dustLayerCount: Int
    let dustPointCount: Int
    let dustSizeRange: ClosedRange<CGFloat>
    let dustMinOpacity: Double
    let dustMaxOpacity: Double
    let dustAnimationDuration: Double
    
    let starColors: [Color]
    let starCount: Int
    let starSizeRange: ClosedRange<CGFloat>
    let starMinOpacity: Double
    let starMaxOpacity: Double
    let starAnimationDuration: Double
    
    let phaseAnimationDuration: Double
}

extension GameSpecialBoardNebulaStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardNebulaStyle {
        GameSpecialBoardNebulaStyle(
            nebulaColors: [
                Color(red: 0.2, green: 0.0, blue: 0.5),
                Color(red: 0.1, green: 0.0, blue: 0.3),
                Color(red: 0.5, green: 0.1, blue: 0.4),
                Color(red: 0.0, green: 0.2, blue: 0.5),
                Color(red: 0.3, green: 0.0, blue: 0.6),
                Color(red: 0.0, green: 0.3, blue: 0.6)
            ],
            nebulaCount: 5,
            blobPointCount: 8,
            blobIrregularity: 0.4,
            blobSizeMultiplier: 1.2,
            blobOpacity: 0.4,
            blobBlurRadius: 30,
            blobAnimationDuration: 8.0,
            
            dustColors: [.white, Color(red: 0.9, green: 0.9, blue: 1.0)],
            dustLayerCount: 3,
            dustPointCount: 200,
            dustSizeRange: 0.5...1.5,
            dustMinOpacity: 0.4,
            dustMaxOpacity: 0.7,
            dustAnimationDuration: 4.0,
            
            starColors: [.white, Color(red: 0.9, green: 0.95, blue: 1.0), Color(red: 1.0, green: 0.9, blue: 0.8)],
            starCount: 25,
            starSizeRange: 2...4,
            starMinOpacity: 0.6,
            starMaxOpacity: 1.0,
            starAnimationDuration: 2.0,
            
            phaseAnimationDuration: 30.0
        )
    }
}
