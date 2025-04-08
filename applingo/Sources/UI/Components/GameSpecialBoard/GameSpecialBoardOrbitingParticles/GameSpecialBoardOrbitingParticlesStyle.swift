import SwiftUI

struct GameSpecialBoardOrbitingParticlesStyle {
    let ringColors: [Color]
    let particleColors: [Color]
    let gradientColors: [Color]
    
    let ringCount: Int
    let ringWidth: CGFloat
    let ringOpacity: Double
    let ringScales: [CGFloat]
    
    let orbitCount: Int
    let orbitRadiusFactors: [CGFloat]
    let particlesPerOrbit: [Int]
    
    let particleSize: CGFloat
    let minParticleOpacity: Double
    let maxParticleOpacity: Double
    let particleAnimationDuration: Double
    let particleDelayStep: Double
    
    let cardCornerRadius: CGFloat
    let cardBorderWidth: CGFloat
    let cardWidthFactor: CGFloat
    let cardHeightFactor: CGFloat
    let minBorderOpacity: Double
    let maxBorderOpacity: Double
    let borderAnimationDuration: Double
    
    let rotationDuration: Double
}

extension GameSpecialBoardOrbitingParticlesStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardOrbitingParticlesStyle {
        let primaryColor = Color.blue
        let secondaryColor = Color.purple
        
        return GameSpecialBoardOrbitingParticlesStyle(
            ringColors: [primaryColor, secondaryColor, primaryColor.opacity(0.6)],
            particleColors: [
                primaryColor,
                secondaryColor,
                Color.cyan,
                Color.indigo
            ],
            gradientColors: [
                primaryColor,
                secondaryColor,
                primaryColor,
                secondaryColor
            ],
            
            ringCount: 3,
            ringWidth: 1.5,
            ringOpacity: 0.5,
            ringScales: [0.9, 1.2, 1.5],
            
            orbitCount: 4,
            orbitRadiusFactors: [0.65, 0.85, 1.05, 1.25],
            particlesPerOrbit: [10, 15, 20, 25],
            
            particleSize: 5,
            minParticleOpacity: 0.4,
            maxParticleOpacity: 0.9,
            particleAnimationDuration: 2.0,
            particleDelayStep: 0.08,
            
            cardCornerRadius: 16,
            cardBorderWidth: 2,
            cardWidthFactor: 0.7,
            cardHeightFactor: 0.9,
            minBorderOpacity: 0.6,
            maxBorderOpacity: 1.0,
            borderAnimationDuration: 3.0,
            
            rotationDuration: 60.0
        )
    }
}

extension GameSpecialBoardOrbitingParticlesStyle {
    static func colors(_ theme: AppTheme, colors: [Color]) -> GameSpecialBoardOrbitingParticlesStyle {
        return GameSpecialBoardOrbitingParticlesStyle(
            ringColors: colors,
            particleColors: colors,
            gradientColors: colors,
            
            ringCount: 3,
            ringWidth: 1.5,
            ringOpacity: 0.5,
            ringScales: [0.9, 1.2, 1.5],
            
            orbitCount: 4,
            orbitRadiusFactors: [0.65, 0.85, 1.05, 1.25],
            particlesPerOrbit: [10, 15, 20, 25],
            
            particleSize: 5,
            minParticleOpacity: 0.4,
            maxParticleOpacity: 0.9,
            particleAnimationDuration: 2.0,
            particleDelayStep: 0.08,
            
            cardCornerRadius: 16,
            cardBorderWidth: 2,
            cardWidthFactor: 0.7,
            cardHeightFactor: 0.9,
            minBorderOpacity: 0.6,
            maxBorderOpacity: 1.0,
            borderAnimationDuration: 3.0,
            
            rotationDuration: 60.0
        )
    }
}
