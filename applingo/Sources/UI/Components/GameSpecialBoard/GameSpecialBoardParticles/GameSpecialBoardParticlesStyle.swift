import SwiftUI

struct GameSpecialBoardParticlesStyle {
    let backgroundColor: Color
    let particleColors: [Color]
    let minParticleSize: CGFloat
    let maxParticleSize: CGFloat
    let particleCount: Int
    let maxSpeed: CGFloat
    let randomness: CGFloat
    let trailLength: Int
    let maxOpacity: Double
}

extension GameSpecialBoardParticlesStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardParticlesStyle {
        GameSpecialBoardParticlesStyle(
            backgroundColor: .black.opacity(0.1),
            particleColors: [.red, .orange, .yellow, .green, .blue, .purple],
            minParticleSize: 2,
            maxParticleSize: 8,
            particleCount: 30,
            maxSpeed: 2.5,
            randomness: 0.1,
            trailLength: 15,
            maxOpacity: 0.7
        )
    }
}
