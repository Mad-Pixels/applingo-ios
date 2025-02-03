import SwiftUI

// MARK: - ChartIndicatorStyle
/// Defines styling parameters for the ChartIndicator component.
struct ChartIndicatorStyle {
    let backgroundColor: Color
    let gradientColors: [Color]
    let height: CGFloat
    let cornerRadius: CGFloat
    let animation: Animation
    let glowRadius: CGFloat
    let glowOpacity: CGFloat
    let withGlowAnimation: Bool
    
    /// Returns a themed style based on the provided AppTheme.
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
            glowRadius: 4,
            glowOpacity: 0.3,
            withGlowAnimation: true
        )
    }
}
