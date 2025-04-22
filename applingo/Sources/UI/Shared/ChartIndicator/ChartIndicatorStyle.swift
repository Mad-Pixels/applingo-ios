import SwiftUI

struct ChartIndicatorStyle {
    // Color Properties
    let backgroundColor: Color
    let gradientColors: [Color]

    // Layout Properties
    let height: CGFloat
    let cornerRadius: CGFloat

    // Animation Properties
    let animation: Animation
    let withGlowAnimation: Bool

    // Glow Effect Properties
    let glowRadius: CGFloat
    let glowOpacity: CGFloat
}

extension ChartIndicatorStyle {
    static func themed(_ theme: AppTheme) -> ChartIndicatorStyle {
        ChartIndicatorStyle(
            backgroundColor: theme.backgroundSecondary.opacity(0.5),
            gradientColors: [
                theme.accentPrimary.opacity(0.7),
                theme.accentPrimary
            ],
            height: 6,
            cornerRadius: 3,
            animation: .spring(response: 0.3),
            withGlowAnimation: true,
            glowRadius: 4,
            glowOpacity: 0.3
        )
    }
    
    static func md(_ theme: AppTheme) -> ChartIndicatorStyle {
        ChartIndicatorStyle(
            backgroundColor: theme.backgroundSecondary.opacity(0.5),
            gradientColors: [
                theme.accentPrimary.opacity(0.7),
                theme.accentPrimary
            ],
            height: 10,
            cornerRadius: 3,
            animation: .spring(response: 0.3),
            withGlowAnimation: true,
            glowRadius: 4,
            glowOpacity: 0.3
        )
    }
}
