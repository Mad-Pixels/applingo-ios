import SwiftUI

// MARK: - DonutChartViewLegend
/// A view that displays the legend for the donut chart, with an optional title.
struct DonutChartViewLegend: View {
    let data: [DonutChartModel]
    let style: DonutChartStyle
    let legendTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: style.legendSpacing) {
            Text(legendTitle)
                .font(style.legendTitleFont)
                .foregroundColor(style.legendColor)
            ForEach(data) { segment in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(segment.color)
                        .frame(width: 16, height: 16)
                    Text(verbatim: "\(segment.label): \(Int(segment.value))")
                        .font(style.legendFont)
                        .foregroundColor(style.legendColor)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
