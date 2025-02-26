import SwiftUI

// MARK: - DonutChart View
/// An enhanced donut chart with interactive segments, a static center value, and an optional legend.
/// - Left: The donut chart displays segments with a glowing radial gradient.
/// - Center: A number (centerValue) is shown inside a circular background.
/// - Right: An optional legend displays each segment’s label and value.
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
    
    /// Computed data for the chart slices.
    /// If total == 0, a fallback segment is used for chart rendering.
    private var actualData: [DonutChartModel] {
        if data.reduce(0, { $0 + $1.value }) == 0 {
            return [DonutChartModel(value: 1, label: "", color: style.emptyColor)]
        } else {
            return data
        }
    }
    
    /// Total value of segments (fallback total is 1 if data is empty).
    private var total: Double {
        let sum = data.reduce(0) { $0 + $1.value }
        return sum == 0 ? 1 : sum
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                ForEach(Array(actualData.enumerated()), id: \.element.id) { index, segment in
                    DonutChartViewSlice(
                        index: index,
                        data: actualData,
                        total: total,
                        style: style
                    )
                }
                
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
            .padding(style.chartPadding)
            
            if let legendTitle = legendTitle, !legendTitle.isEmpty {
                DonutChartViewLegend(data: data, style: style, legendTitle: legendTitle)
            }
        }
    }
}
