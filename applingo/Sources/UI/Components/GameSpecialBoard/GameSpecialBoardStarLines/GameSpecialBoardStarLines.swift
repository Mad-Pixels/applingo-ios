import SwiftUI

struct GameSpecialBoardStarLines: View {
    @State private var animate = false
    
    let style: GameSpecialBoardStarLinesStyle
    
    init(style: GameSpecialBoardStarLinesStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<style.lineCount, id: \.self) { i in
                    let angle = Double(i) * (360.0 / Double(style.lineCount))
                    
                    // Рассчитываем длину линии до края экрана
                    let screenSize = max(geo.size.width, geo.size.height) * 2
                    
                    Line()
                        .stroke(
                            style.lineColors[i % style.lineColors.count],
                            style: StrokeStyle(
                                lineWidth: style.lineWidth,
                                lineCap: .round
                            )
                        )
                        // Устанавливаем размер, чтобы линия гарантированно доходила до края экрана
                        .frame(width: screenSize, height: style.lineWidth)
                        .rotationEffect(.degrees(angle))
                        .scaleEffect(animate ? style.maxScale : style.minScale)
                        .opacity(animate ? 0 : style.maxOpacity)
                        .animation(
                            Animation.easeOut(duration: style.animationDuration)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i % style.phaseGroups) * style.delayBetweenLines),
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
