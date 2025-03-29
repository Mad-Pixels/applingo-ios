import SwiftUI

struct DonutChart: View {
    let data: [DonutChartModel]
    let centerValue: String
    let style: DonutChartStyle
    let legendTitle: String?

    /// Initializes the DonutChart.
    /// - Parameters:
    ///   - data: An array of DonutChartModel defining the segments.
    ///   - centerValue: The number (as String) to display in the center.
    ///   - legendTitle: An optional title for the legend.
    ///   - style: The style for the picker. Defaults to themed style using the current theme.
    init(
        data: [DonutChartModel],
        centerValue: String,
        legendTitle: String? = nil,
        style: DonutChartStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.centerValue = centerValue
        self.legendTitle = legendTitle
        self.style = style
        self.data = data
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                ForEach(Array(actualData.enumerated()), id: \.element.id) { index, segment in
                    DonutChartViewSliceView(
                        index: index,
                        total: total,
                        data: actualData,
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
                DonutChartViewLegendView(data: data, style: style, legendTitle: legendTitle)
            }
        }
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
}
