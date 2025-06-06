import SwiftUI

struct ChartIndicator: View {
    @State private var isGlowing = false
    
    let weight: Int
    let style: ChartIndicatorStyle
    
    /// Initializes the ChartIndicator.
    /// - Parameters:
    ///   - weight: An integer value between 0 and 1000 determining the progress.
    ///   - style: The style for the chart indicator. Defaults to themed style.
    init(
        weight: Int,
        style: ChartIndicatorStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.weight = max(0, min(1000, weight))
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(style.backgroundColor)
                    .frame(width: geometry.size.width, height: style.height)
                
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(style.height, geometry.size.width * progress), height: style.height)
                    .shadow(
                        color: gradientColors.last?.opacity(style.glowOpacity * (isGlowing ? 1 : 0.5)) ?? .clear,
                        radius: style.glowRadius,
                        x: 0,
                        y: 0
                    )
                    .animation(style.animation, value: weight)
                
                if progress > 0.1 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ]
                                ),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: max(style.height, geometry.size.width * progress), height: style.height / 2)
                        .offset(y: -style.height / 4)
                }
            }
        }
        .frame(height: style.height)
        .onAppear {
            if style.withGlowAnimation {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }
        }
        .accessibilityValue("\(Int(progress * 100))%")
    }
    
    /// Computes the progress ratio based on weight.
    private var progress: CGFloat {
        CGFloat(weight) / 1000.0
    }
    
    /// Determines gradient colors with varying opacity based on the weight.
    private var gradientColors: [Color] {
        if weight < 300 {
            return style.gradientColors.map { $0.opacity(0.4) }
        } else if weight < 700 {
            return style.gradientColors.map { $0.opacity(0.7) }
        }
        return style.gradientColors
    }
}
