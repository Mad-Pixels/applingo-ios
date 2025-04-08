import SwiftUI

struct GameSpecialBoardSpaceDust: View {
    @State private var animate = false
    @State private var rotation: Double = 0
    
    let style: GameSpecialBoardSpaceDustStyle
    
    init(style: GameSpecialBoardSpaceDustStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Фоновые звезды
                ForEach(0..<style.starCount, id: \.self) { i in
                    let size = CGFloat.random(in: style.minStarSize...style.maxStarSize)
                    let x = CGFloat.random(in: 0...geo.size.width)
                    let y = CGFloat.random(in: 0...geo.size.height)
                    let delay = Double.random(in: 0...style.animationDuration)
                    
                    Circle()
                        .fill(style.starColors[i % style.starColors.count])
                        .frame(width: size, height: size)
                        .position(x: x, y: y)
                        .opacity(animate ? style.maxOpacity : style.minOpacity)
                        .blur(radius: animate ? 0 : 1)
                        .animation(
                            Animation.easeInOut(duration: style.animationDuration)
                                .repeatForever(autoreverses: true)
                                .delay(delay),
                            value: animate
                        )
                }
                
                ForEach(0..<style.dustCloudCount, id: \.self) { i in
                    GameSpecialBoardSpaceDustShape(points: style.dustPointsPerCloud)
                        .fill(
                            style.dustColors[i % style.dustColors.count]
                                .opacity(style.dustOpacity)
                        )
                        .frame(
                            width: geo.size.width * style.dustCloudScale,
                            height: geo.size.height * style.dustCloudScale
                        )
                        .position(
                            x: geo.size.width / 2,
                            y: geo.size.height / 2
                        )
                        .rotationEffect(.degrees(Double(i) * 360 / Double(style.dustCloudCount) + rotation))
                        .blur(radius: style.dustBlur)
                }
                
                ForEach(0..<style.brightStarCount, id: \.self) { i in
                    let size = CGFloat.random(in: style.brightStarMinSize...style.brightStarMaxSize)
                    let x = CGFloat.random(in: 0...geo.size.width)
                    let y = CGFloat.random(in: 0...geo.size.height)
                    let delay = Double.random(in: 0...style.animationDuration)
                    
                    ZStack {
                        Circle()
                            .fill(style.brightStarColors[i % style.brightStarColors.count])
                            .frame(width: size, height: size)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        style.brightStarColors[i % style.brightStarColors.count],
                                        style.brightStarColors[i % style.brightStarColors.count].opacity(0)
                                    ]),
                                    center: .center,
                                    startRadius: size / 2,
                                    endRadius: size * 2
                                )
                            )
                            .frame(width: size * 4, height: size * 4)
                    }
                    .position(x: x, y: y)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .opacity(animate ? style.brightStarMaxOpacity : style.brightStarMinOpacity)
                    .animation(
                        Animation.easeInOut(duration: style.animationDuration * 0.7)
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
            withAnimation(.linear(duration: style.rotationDuration).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .drawingGroup()
    }
}
