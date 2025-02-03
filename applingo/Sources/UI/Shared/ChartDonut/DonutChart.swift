import SwiftUI

import SwiftUI

// MARK: - DonutChart View
/// An enhanced donut chart with a static center value and legend.
/// - Left: The donut chart displays segments with a glowing radial gradient.
/// - Center: A number (centerValue) is shown inside a circle background.
/// - Right: A legend lists each segment’s label and value.
struct DonutChart: View {
    let data: [DonutChartModel]
    let centerValue: String
    let style: DonutChartStyle

    /// Initializes the DonutChart.
    /// - Parameters:
    ///   - data: An array of DonutChartModel defining the segments.
    ///   - centerValue: The number (as String) to display in the center.
    ///   - style: The style for the chart. Defaults to themed style.
    init(
        data: [DonutChartModel],
        centerValue: String,
        style: DonutChartStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.data = data
        self.centerValue = centerValue
        self.style = style
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
                    DonutSlice(
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
                            .fill(Color.white.opacity(0.8))
                    )
            }
            .frame(width: style.donutSize, height: style.donutSize)
            
            // Legend (right side)
            VStack(alignment: .leading, spacing: style.legendSpacing) {
                ForEach(data) { segment in
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(segment.color)
                            .frame(width: 16, height: 16)
                        Text("\(segment.label): \(Int(segment.value))")
                            .font(style.legendFont)
                            .foregroundColor(style.legendColor)
                    }
                }
            }
        }
    }
}


import SwiftUI

/// Draws a single segment of the donut chart with a glowing overlay.
/// The segment's line width is dynamically scaled using a non-linear (square-root) function,
/// with a stronger difference between small and large segments.
struct DonutSlice: View {
    let index: Int
    let data: [DonutChartModel]
    let total: Double
    let style: DonutChartStyle

    // Current segment.
    private var segment: DonutChartModel { data[index] }
    
    // Maximum value among segments.
    private var maxValue: Double {
        data.map { $0.value }.max() ?? style.lineWidth
    }
    
    // Use a non-linear scaling (sqrt) with a larger range: factor from 0.5 to 1.0.
    private var dynamicLineWidth: CGFloat {
        let normalized = segment.value / maxValue
        let factor = 0.5 + 0.5 * CGFloat(sqrt(normalized))
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
        Circle()
            .trim(from: CGFloat((startAngle.degrees + 90) / 360),
                  to: CGFloat((endAngle.degrees + 90) / 360))
            .stroke(
                segment.color,
                style: StrokeStyle(lineWidth: dynamicLineWidth, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .overlay(
                // Radial gradient overlay for a stronger glowing effect.
                Circle()
                    .trim(from: CGFloat((startAngle.degrees + 90) / 360),
                          to: CGFloat((endAngle.degrees + 90) / 360))
                    .stroke(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                segment.color.opacity(0.9),
                                segment.color.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: dynamicLineWidth * 3
                        ),
                        style: StrokeStyle(lineWidth: dynamicLineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            )
            .animation(.easeInOut(duration: style.animationDuration), value: total)
    }
}



