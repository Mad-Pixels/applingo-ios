import SwiftUI

struct AudioLevelVisualizer: View {
    let level: CGFloat
    let style: AudioLevelVisualizerStyle

    var body: some View {
        GeometryReader { geo in
            let segmentWidth = (geo.size.width - CGFloat(style.segmentCount - 1) * style.barSpacing) / CGFloat(style.segmentCount)

            HStack(spacing: style.barSpacing) {
                ForEach(0..<style.segmentCount, id: \.self) { index in
                    let threshold = CGFloat(index + 1) / CGFloat(style.segmentCount)
                    let isActive = level >= threshold
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .fill(isActive ? barColor(for: threshold) : style.inactiveColor)
                        .frame(width: segmentWidth, height: style.barHeight)
                }
            }
        }
        .frame(height: style.barHeight)
        .padding(.horizontal)
    }

    private func barColor(for threshold: CGFloat) -> Color {
        switch threshold {
        case 0..<0.4: return style.activeColorLow
        case 0.4..<0.7: return style.activeColorMid
        default: return style.activeColorHigh
        }
    }
}
