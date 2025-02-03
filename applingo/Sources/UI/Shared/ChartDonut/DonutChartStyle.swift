import SwiftUI

// MARK: - DonutChartStyle
/// Defines styling parameters for the DonutChart component.
struct DonutChartStyle {
    let donutSize: CGFloat
    let lineWidth: CGFloat
    let legendSpacing: CGFloat
    let legendFont: Font
    let legendColor: Color
    let centerValueBackground: Color
    let centerValueFont: Font
    let centerValueColor: Color
    let animationDuration: Double
    let legendTitleColor: Color
    let legendTitleFont: Font
    let emptyColor: Color
    let chartPadding: EdgeInsets
}

extension DonutChartStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme) -> DonutChartStyle {
        DonutChartStyle(
            donutSize: 120,
            lineWidth: 20,
            legendSpacing: 8,
            legendFont: .subheadline,
            legendColor: theme.textPrimary,
            centerValueBackground: theme.backgroundPrimary,
            centerValueFont: .system(size: 16).bold(),
            centerValueColor: theme.textPrimary,
            animationDuration: 0.5,
            legendTitleColor: theme.textPrimary,
            legendTitleFont: .system(size: 18, weight: .bold),
            emptyColor: theme.backgroundPrimary,
            chartPadding: EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 42)
        )
    }
}
