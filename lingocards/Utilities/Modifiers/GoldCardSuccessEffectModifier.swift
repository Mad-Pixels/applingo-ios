import SwiftUI

struct GoldCardSuccessEffectModifier: ViewModifier {
    @Binding var isActive: Bool
    @State private var particlesOpacity: Double = 0
    @State private var particles: [(CGPoint, Double)] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ForEach(0..<particles.count, id: \.self) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 8, height: 8)
                            .position(particles[index].0)
                            .opacity(particles[index].1)
                    }
                }
                .opacity(particlesOpacity)
            )
            .onChange(of: isActive) { newValue in
                if newValue {
                    createParticles()
                    withAnimation(.easeOut(duration: 1)) {
                        particlesOpacity = 1
                        updateParticles()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            particlesOpacity = 0
                            particles = []
                        }
                    }
                }
            }
    }
    
    private func createParticles() {
        particles = (0..<20).map { _ in
            let randomAngle = Double.random(in: 0..<2 * .pi)
            let randomRadius = CGFloat.random(in: 50...100)
            let x = cos(randomAngle) * randomRadius + 200
            let y = sin(randomAngle) * randomRadius + 200
            return (CGPoint(x: x, y: y), Double.random(in: 0.5...1))
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            let currentPosition = particles[i].0
            let newX = currentPosition.x + CGFloat.random(in: -50...50)
            let newY = currentPosition.y - CGFloat.random(in: 50...100)
            particles[i].0 = CGPoint(x: newX, y: newY)
            particles[i].1 *= 0.5
        }
    }
}
