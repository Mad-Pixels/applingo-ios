import SwiftUI

/// Draws a single segment of the donut chart with dynamic line width.
/// Larger segments are drawn thicker, while smaller segments are thinner.
struct DonutChartViewSlice: View {
    let index: Int
    let data: [DonutChartModel]
    let total: Double
    let style: DonutChartStyle

    // Current segment.
    private var segment: DonutChartModel { data[index] }
    
    // Maximum value among all segments.
    private var maxValue: Double {
        data.map { $0.value }.max() ?? segment.value
    }
    
    // Dynamic line width using a non-linear scaling:
    // Factor ranges from ~0.4 for the smallest segments to ~1.4 for the largest.
    private var dynamicLineWidth: CGFloat {
        let normalized = segment.value / maxValue
        let factor = 0.4 + 1.0 * CGFloat(sqrt(normalized))
        return style.lineWidth * factor
    }
    
    /// Computes the start angle for this segment.
    private var startAngle: Angle {
        let sum = data.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: (sum / total) * 360 - 90)
    }
    
    /// Computes the end angle for this segment.
    private var endAngle: Angle {
        let sum = data.prefix(index + 1).reduce(0) { $0 + $1.value }
        return Angle(degrees: (sum / total) * 360 - 90)
    }
    
    var body: some View {
        GeometryReader { _ in
            Circle()
                .trim(from: CGFloat((startAngle.degrees + 90) / 360),
                      to: CGFloat((endAngle.degrees + 90) / 360))
                .stroke(segment.color,
                        style: StrokeStyle(lineWidth: dynamicLineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: style.animationDuration), value: total)
        }
    }
}
