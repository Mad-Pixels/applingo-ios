import SwiftUI

struct DonutChartViewLegendView: View {
    internal let data: [DonutChartModel]
    internal let style: DonutChartStyle
    internal let legendTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: style.legendSpacing) {
            DynamicText(
                model: DynamicTextModel(text: legendTitle),
                style: .headerBlock(ThemeManager.shared.currentThemeStyle)
            )
            ForEach(data) { segment in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(segment.color)
                        .frame(width: 16, height: 16)
                    
                    DynamicText(
                        model: DynamicTextModel(text: "\(segment.label): \(Int(segment.value))"),
                        style: .textLight(ThemeManager.shared.currentThemeStyle)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
