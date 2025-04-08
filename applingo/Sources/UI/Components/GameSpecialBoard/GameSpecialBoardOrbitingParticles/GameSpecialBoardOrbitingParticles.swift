import SwiftUI

struct GameSpecialBoardOrbitingParticles: View {
    @State private var animate = false
    @State private var rotation: Double = 0
    
    let style: GameSpecialBoardOrbitingParticlesStyle
    
    init(style: GameSpecialBoardOrbitingParticlesStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<style.ringCount, id: \.self) { i in
                    ZStack {
                        Circle()
                            .stroke(
                                style.ringColors[i % style.ringColors.count],
                                lineWidth: style.ringWidth
                            )
                            .opacity(style.ringOpacity)
                    }
                    .frame(
                        width: geo.size.width * style.ringScales[i % style.ringScales.count],
                        height: geo.size.height * style.ringScales[i % style.ringScales.count]
                    )
                    .rotationEffect(.degrees(rotation * (i.isMultiple(of: 2) ? 1 : -1)))
                }
                
                ForEach(0..<style.orbitCount, id: \.self) { orbitIndex in
                    let orbitRadius = geo.size.width * 0.5 * style.orbitRadiusFactors[orbitIndex % style.orbitRadiusFactors.count]
                    let particleCount = style.particlesPerOrbit[orbitIndex % style.particlesPerOrbit.count]
                    
                    ForEach(0..<particleCount, id: \.self) { i in
                        let angle = Double(i) * (360.0 / Double(particleCount))
                        let delay = Double(i) * style.particleDelayStep
                        
                        Circle()
                            .fill(style.particleColors[orbitIndex % style.particleColors.count])
                            .frame(width: style.particleSize, height: style.particleSize)
                            .offset(x: 0, y: -orbitRadius)
                            .rotationEffect(.degrees(angle))
                            .rotationEffect(.degrees(rotation * (orbitIndex.isMultiple(of: 2) ? 1 : -1)))
                            .opacity(animate ? style.maxParticleOpacity : style.minParticleOpacity)
                            .scaleEffect(animate ? 1.0 : 0.5)
                            .blur(radius: animate ? 0 : 2)
                            .animation(
                                Animation.easeInOut(duration: style.particleAnimationDuration)
                                    .repeatForever(autoreverses: true)
                                    .delay(delay),
                                value: animate
                            )
                    }
                }
                
                RoundedRectangle(cornerRadius: style.cardCornerRadius)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: style.gradientColors),
                            center: .center
                        ),
                        lineWidth: style.cardBorderWidth
                    )
                    .frame(
                        width: geo.size.width * style.cardWidthFactor,
                        height: geo.size.height * style.cardHeightFactor
                    )
                    .opacity(animate ? style.maxBorderOpacity : style.minBorderOpacity)
                    .animation(
                        Animation.easeInOut(duration: style.borderAnimationDuration)
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
                    .rotationEffect(.degrees(rotation * 0.2))
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
