import SwiftUI

struct GameSpecialBoardPulsingCircles: View {
    @State private var animate = false
    
    let style: GameSpecialBoardPulsingCirclesStyle
    
    init(style: GameSpecialBoardPulsingCirclesStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<style.circleCount, id: \.self) { i in
                    Circle()
                        .stroke(
                            style.circleColors[i % style.circleColors.count],
                            lineWidth: style.lineWidth
                        )
                        .scaleEffect(animate ? style.maxScale : style.minScale)
                        .opacity(animate ? 0 : style.maxOpacity)
                        .animation(
                            Animation.easeOut(duration: style.animationDuration)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * style.delayBetweenCircles),
                            value: animate
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animate = true
        }
    }
}
