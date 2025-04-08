import SwiftUI

struct AudioLevelVisualizerStyle {
    // Segment Layout
    let segmentCount: Int
    let barHeight: CGFloat
    let barSpacing: CGFloat
    let cornerRadius: CGFloat

    // Segment Colors
    let activeColorLow: Color
    let activeColorMid: Color
    let activeColorHigh: Color
    let inactiveColor: Color

    // Background
    let backgroundColor: Color
}

extension AudioLevelVisualizerStyle {
    static func themed(_ theme: AppTheme) -> AudioLevelVisualizerStyle {
        AudioLevelVisualizerStyle(
            segmentCount: 20,
            barHeight: 12,
            barSpacing: 2,
            cornerRadius: 4,
            activeColorLow: theme.accentLight,
            activeColorMid: theme.accentPrimary,
            activeColorHigh: theme.accentDark,
            inactiveColor: .gray.opacity(0.2),
            backgroundColor: theme.backgroundSecondary.opacity(0.3)
        )
    }
}
