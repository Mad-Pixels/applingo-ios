import SwiftUI

struct ChartIndicatorStyle {
    let backgroundColor: Color
    let gradientColors: [Color]
    let height: CGFloat
    let cornerRadius: CGFloat
    let animation: Animation
    let glowRadius: CGFloat
    let glowOpacity: CGFloat
    let withGlowAnimation: Bool
    
    static func themed(_ theme: AppTheme) -> ChartIndicatorStyle {
        ChartIndicatorStyle(
            backgroundColor: theme.backgroundSecondary.opacity(0.5),
            gradientColors: [
                theme.accentPrimary.opacity(0.7),
                theme.accentPrimary
            ],
            height: 6, // Немного увеличил высоту
            cornerRadius: 3,
            animation: .spring(response: 0.3),
            glowRadius: 4,
            glowOpacity: 0.3,
            withGlowAnimation: true
        )
    }
}
