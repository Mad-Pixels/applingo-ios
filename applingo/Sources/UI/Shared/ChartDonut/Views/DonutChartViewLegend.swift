import SwiftUI

// MARK: - DonutChartViewLegend
/// A view that displays the legend for the donut chart.
/// If a legend title is provided, it is shown above the legend items.
struct DonutChartViewLegend: View {
    let data: [DonutChartModel]
    let style: DonutChartStyle
    let legendTitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: style.legendSpacing) {
            if let title = legendTitle, !title.isEmpty {
                Text(title)
                    .font(style.legendValueFont)
                    .foregroundColor(style.legendTitleColor)
            }
            ForEach(data) { segment in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(segment.color)
                        .frame(width: 16, height: 16)
                    Text("\(segment.label): \(Int(segment.value))")
                        .font(style.legendFont)
                        .foregroundColor(style.legendColor)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
