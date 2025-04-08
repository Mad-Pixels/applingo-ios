import SwiftUI

struct GameSpecialBoardNebula: View {
    @State private var animate = false
    @State private var phase: Double = 0
    
    let style: GameSpecialBoardNebulaStyle
    
    init(style: GameSpecialBoardNebulaStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<style.nebulaCount, id: \.self) { i in
                    GameSpecialBoardNebulaStarLayer(points: style.blobPointCount, irregularity: style.blobIrregularity)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    style.nebulaColors[(i * 2) % style.nebulaColors.count],
                                    style.nebulaColors[(i * 2 + 1) % style.nebulaColors.count]
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: geo.size.width * style.blobSizeMultiplier,
                            height: geo.size.height * style.blobSizeMultiplier
                        )
                        .position(
                            x: geo.size.width / 2 + cos(Double(i) * 0.7 + phase) * geo.size.width * 0.2,
                            y: geo.size.height / 2 + sin(Double(i) * 0.5 + phase) * geo.size.height * 0.2
                        )
                        .opacity(style.blobOpacity)
                        .blur(radius: style.blobBlurRadius)
                        .animation(
                            .easeInOut(duration: style.blobAnimationDuration)
                                .repeatForever(autoreverses: true),
                            value: phase
                        )
                }
                
                ForEach(0..<style.dustLayerCount, id: \.self) { i in
                    GameSpecialBoardNebulaDustLayer(pointCount: style.dustPointCount, sizeRange: style.dustSizeRange)
                        .fill(style.dustColors[i % style.dustColors.count])
                        .frame(width: geo.size.width, height: geo.size.height)
                        .opacity(animate ? style.dustMaxOpacity : style.dustMinOpacity)
                        .blendMode(.screen)
                        .animation(
                            .easeInOut(duration: style.dustAnimationDuration)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.3),
                            value: animate
                        )
                }
                
                ForEach(0..<style.starCount, id: \.self) { i in
                    let size = CGFloat.random(in: style.starSizeRange.lowerBound...style.starSizeRange.upperBound)
                    let x = CGFloat.random(in: 0...geo.size.width)
                    let y = CGFloat.random(in: 0...geo.size.height)
                    let delay = Double.random(in: 0...2)
                    
                    ZStack {
                        Circle()
                            .fill(style.starColors[i % style.starColors.count])
                            .frame(width: size, height: size)
                            .blur(radius: 0.5)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        style.starColors[i % style.starColors.count].opacity(0.8),
                                        style.starColors[i % style.starColors.count].opacity(0)
                                    ]),
                                    center: .center,
                                    startRadius: size / 2,
                                    endRadius: size * 3
                                )
                            )
                            .frame(width: size * 6, height: size * 6)
                    }
                    .position(x: x, y: y)
                    .opacity(animate ? style.starMaxOpacity : style.starMinOpacity)
                    .animation(
                        .easeInOut(duration: style.starAnimationDuration)
                            .repeatForever(autoreverses: true)
                            .delay(delay),
                        value: animate
                    )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animate = true
            withAnimation(.linear(duration: style.phaseAnimationDuration).repeatForever(autoreverses: false)) {
                phase = 2 * .pi
            }
        }
        .drawingGroup()
    }
}
