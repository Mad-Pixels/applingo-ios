import SwiftUI

struct DonutChartStyle {
    // Chart Dimensions
    let donutSize: CGFloat
    let lineWidth: CGFloat

    // Legend Properties
    let legendSpacing: CGFloat
    let legendColor: Color

    // Center Value Properties
    let centerValueBackground: Color
    let centerValueFont: Font
    let centerValueColor: Color

    // Appearance Properties
    let emptyColor: Color
    let chartPadding: EdgeInsets

    // Animation Properties
    let animationDuration: Double
}

extension DonutChartStyle {
    static func themed(_ theme: AppTheme) -> DonutChartStyle {
        DonutChartStyle(
            donutSize: 120,
            lineWidth: 20,
            legendSpacing: 8,
            legendColor: theme.textPrimary,
            centerValueBackground: theme.backgroundPrimary,
            centerValueFont: .system(size: 16).bold(),
            centerValueColor: theme.textPrimary,
            emptyColor: theme.backgroundPrimary,
            chartPadding: EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 42),
            animationDuration: 0.5
        )
    }
}
