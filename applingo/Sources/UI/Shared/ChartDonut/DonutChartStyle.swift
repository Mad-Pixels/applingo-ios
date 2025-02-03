import SwiftUI

// MARK: - DonutChartStyle
/// Defines styling parameters for the DonutChart component.
struct DonutChartStyle {
    let donutSize: CGFloat        // Diameter of the donut chart.
    let lineWidth: CGFloat        // Thickness of the donut segments.
    let legendSpacing: CGFloat    // Spacing between legend items.
    let legendFont: Font          // Font for legend text.
    let legendColor: Color        // Color for legend text.
    let centerValueFont: Font     // Font for the central number.
    let centerValueColor: Color   // Color for the central number.
    let animationDuration: Double // Animation duration for drawing arcs.
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
            centerValueFont: .largeTitle.bold(),
            centerValueColor: theme.textPrimary,
            animationDuration: 0.5
        )
    }
}
