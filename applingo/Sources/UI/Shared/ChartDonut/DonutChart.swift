import SwiftUI

// MARK: - DonutChart View
/// An enhanced donut chart with interactive segments, a static center value, and an optional legend.
/// - Left: The donut chart displays segments with a glowing radial gradient.
/// - Center: A number (centerValue) is shown inside a circular background.
/// - Right: If a legend title is provided, a legend with the title and segment details is displayed.
struct DonutChart: View {
    let data: [DonutChartModel]
    let centerValue: String
    let style: DonutChartStyle
    let legendTitle: String?

    /// Initializes the DonutChart.
    /// - Parameters:
    ///   - data: An array of DonutChartModel defining the segments.
    ///   - centerValue: The number (as String) to display in the center.
    ///   - style: The style for the chart. Defaults to themed style.
    ///   - legendTitle: An optional title for the legend.
    init(
        data: [DonutChartModel],
        centerValue: String,
        style: DonutChartStyle = .themed(ThemeManager.shared.currentThemeStyle),
        legendTitle: String? = nil
    ) {
        self.data = data
        self.centerValue = centerValue
        self.style = style
        self.legendTitle = legendTitle
    }
    
    /// Total value of all segments.
    private var total: Double {
        data.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Donut Chart (left) with interactive segments and a static center value.
            ZStack {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, segment in
                    DonutChartViewSlice(
                        index: index,
                        data: data,
                        total: total,
                        style: style
                    )
                }
                // Center value with a circular background.
                Text(centerValue)
                    .font(style.centerValueFont)
                    .foregroundColor(style.centerValueColor)
                    .frame(width: style.donutSize * 0.6, height: style.donutSize * 0.6)
                    .background(
                        Circle()
                            .fill(style.centerValueBackground)
                    )
            }
            .frame(width: style.donutSize, height: style.donutSize)
            
            // Legend (right side) - displays only if legendTitle is provided.
            if let legendTitle = legendTitle, !legendTitle.isEmpty {
                DonutChartViewLegend(data: data, style: style, legendTitle: legendTitle)
            }
        }
    }
}
