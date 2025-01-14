import SwiftUI

struct ChartIndicator: View {
    let weight: Int
    let style: ChartIndicatorStyle
    
    init(
        weight: Int,
        style: ChartIndicatorStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.weight = max(0, min(1000, weight))
        self.style = style
    }
    
    private var progress: CGFloat {
        CGFloat(weight) / 1000.0
    }
    
    private var indicatorColor: Color {
        if weight < 300 {
            return style.foregroundColor.opacity(0.4)
        } else if weight < 700 {
            return style.foregroundColor.opacity(0.7)
        } else {
            return style.foregroundColor
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(style.backgroundColor)
                    .frame(width: geometry.size.width, height: style.height)
                    .cornerRadius(style.cornerRadius)
                
                Rectangle()
                    .fill(indicatorColor)
                    .frame(width: geometry.size.width * progress, height: style.height)
                    .cornerRadius(style.cornerRadius)
                    .animation(style.animation, value: weight)
            }
        }
        .frame(height: style.height)
        .accessibilityValue("\(Int(progress * 100))% progress")
    }
}
