import SwiftUI

struct GameSpecialBoardParticles: View {
    let style: GameSpecialBoardParticlesStyle
    
    @State private var particles: [GameSpecialBoardModel] = []
    @State private var timer: Timer? = nil
    
    init(style: GameSpecialBoardParticlesStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            GeometryReader { geo in
                Canvas { context, size in

                    for particle in particles {
                        for i in 0..<min(particle.trailPositions.count, style.trailLength) {
                            let trailOpacity = Double(style.trailLength - i) / Double(style.trailLength) * style.maxOpacity
                            let trailSize = particle.size * (1.0 - Double(i) / Double(style.trailLength))
                            
                            context.opacity = trailOpacity
                            context.fill(
                                Path(ellipseIn: CGRect(
                                    x: particle.trailPositions[i].x - trailSize/2,
                                    y: particle.trailPositions[i].y - trailSize/2,
                                    width: trailSize,
                                    height: trailSize
                                )),
                                with: .color(particle.color)
                            )
                        }
                        
                        context.opacity = style.maxOpacity
                        context.fill(
                            Path(ellipseIn: CGRect(
                                x: particle.position.x - particle.size/2,
                                y: particle.position.y - particle.size/2,
                                width: particle.size,
                                height: particle.size
                            )),
                            with: .color(particle.color)
                        )
                    }
                }
                .onAppear {
                    for _ in 0..<style.particleCount {
                        addParticle(in: geo.size)
                    }
                    
                    timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
                        updateParticles(in: geo.size)
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(style.backgroundColor)
    }
    
    private func addParticle(in size: CGSize) {
        let randomSize = CGFloat.random(in: style.minParticleSize...style.maxParticleSize)
        let colorIndex = Int.random(in: 0..<style.particleColors.count)
        
        let particle = GameSpecialBoardModel(
            id: UUID(),
            position: CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            ),
            velocity: CGPoint(
                x: CGFloat.random(in: -style.maxSpeed...style.maxSpeed),
                y: CGFloat.random(in: -style.maxSpeed...style.maxSpeed)
            ),
            size: randomSize,
            color: style.particleColors[colorIndex],
            trailPositions: []
        )
        
        particles.append(particle)
    }
    
    private func updateParticles(in size: CGSize) {
        for i in 0..<particles.count {
            var particle = particles[i]
            
            particle.trailPositions.insert(particle.position, at: 0)
            if particle.trailPositions.count > style.trailLength {
                particle.trailPositions.removeLast()
            }
            
            particle.position.x += particle.velocity.x
            particle.position.y += particle.velocity.y
            
            if particle.position.x < -particle.size {
                particle.position.x = size.width + particle.size
                particle.trailPositions = []
            } else if particle.position.x > size.width + particle.size {
                particle.position.x = -particle.size
                particle.trailPositions = []
            }
            
            if particle.position.y < -particle.size {
                particle.position.y = size.height + particle.size
                particle.trailPositions = []
            } else if particle.position.y > size.height + particle.size {
                particle.position.y = -particle.size
                particle.trailPositions = []
            }
            
            particle.velocity.x += CGFloat.random(in: -style.randomness...style.randomness)
            particle.velocity.y += CGFloat.random(in: -style.randomness...style.randomness)
            
            let speed = sqrt(particle.velocity.x * particle.velocity.x + particle.velocity.y * particle.velocity.y)
            if speed > style.maxSpeed {
                particle.velocity.x = particle.velocity.x / speed * style.maxSpeed
                particle.velocity.y = particle.velocity.y / speed * style.maxSpeed
            }
            
            particles[i] = particle
        }
    }
}
