import SwiftUI

// MARK: - DonutChart View
/// An enhanced donut chart with a center value and legend.
/// Left: The donut chart displays segments with a glowing radial gradient.
/// Center: A pulsing number (centerValue) is shown over the donut.
/// Right: A legend lists each segment’s label and value.
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
    
    @State private var pulse: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Left: Donut Chart with overlaid pulsing center value.
            ZStack {
                ForEach(Array(data.enumerated()), id: \.element.id) { index, segment in
                    DonutSlice(
                        index: index,
                        data: data,
                        total: total,
                        style: style
                    )
                }
                // Center value with pulsing animation.
                Text(centerValue)
                    .font(style.centerValueFont)
                    .foregroundColor(style.centerValueColor)
                    .scaleEffect(pulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulse)
                    .onAppear { pulse = true }
            }
            .frame(width: style.donutSize, height: style.donutSize)
            
            // Right: Legend
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

// MARK: - DonutSlice View
/// Draws a single segment of the donut chart with a glowing overlay.
struct DonutSlice: View {
    let index: Int
    let data: [DonutChartModel]
    let total: Double
    let style: DonutChartStyle

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
                data[index].color,
                style: StrokeStyle(lineWidth: style.lineWidth, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .overlay(
                // Add a radial gradient overlay for a glowing effect.
                Circle()
                    .trim(from: CGFloat((startAngle.degrees + 90) / 360),
                          to: CGFloat((endAngle.degrees + 90) / 360))
                    .stroke(
                        RadialGradient(
                            gradient: Gradient(colors: [data[index].color.opacity(0.7), data[index].color.opacity(0.1)]),
                            center: .center,
                            startRadius: 0,
                            endRadius: style.lineWidth * 2
                        ),
                        style: StrokeStyle(lineWidth: style.lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
            )
            .animation(.easeInOut(duration: style.animationDuration), value: total)
    }
}
