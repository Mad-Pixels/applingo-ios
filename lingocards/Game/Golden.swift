//import SwiftUI
//
//
//struct GoldenCardConfig {
//    let weightThreshold: Int = 600
//    let goldChance: Double = 1 //0.15
//    let bonusMultiplier: Double = 2.0
//}
//
//protocol GoldenCardEligible {
//    var weight: Int { get }
//}
//
//extension WordItemModel: GoldenCardEligible {}
//
//// MARK: - Сервис для работы с золотыми карточками
//final class GoldenCardService {
//    static let shared = GoldenCardService()
//    private let config = GoldenCardConfig()
//    
//    private init() {}
//    
//    func isGoldenCard(_ word: GoldenCardEligible) -> Bool {
//        guard word.weight <= config.weightThreshold else { return false }
//        return Double.random(in: 0...1) < config.goldChance
//    }
//    
//    func calculateBonusScore(baseScore: Int, isGolden: Bool) -> Int {
//        guard isGolden else { return baseScore }
//        return Int(Double(baseScore) * config.bonusMultiplier)
//    }
//}
//
//// MARK: - Модификаторы для анимаций
//struct GoldenCardModifier: ViewModifier {
//    let isGolden: Bool
//    @State private var glowOpacity: Double = 0
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay(
//                Group {
//                    if isGolden {
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(
//                                LinearGradient(
//                                    colors: [.yellow, .orange],
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                ),
//                                lineWidth: 2
//                            )
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.yellow.opacity(0.5), lineWidth: 4)
//                                    .blur(radius: 4)
//                                    .opacity(glowOpacity)
//                            )
//                    }
//                }
//            )
//            .onAppear {
//                if isGolden {
//                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
//                        glowOpacity = 0.8
//                    }
//                }
//            }
//    }
//}
//
//struct GoldenCardAppearanceModifier: ViewModifier {
//    let isGolden: Bool
//    @State private var scale: CGFloat = 0.8
//    @State private var rotation: Double = -180
//    @State private var opacity: Double = 0
//    
//    func body(content: Content) -> some View {
//        content
//            .scaleEffect(scale)
//            .rotationEffect(.degrees(isGolden ? rotation : 0))
//            .opacity(opacity)
//            .onAppear {
//                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                    scale = 1
//                    rotation = 0
//                    opacity = 1
//                }
//            }
//    }
//}
//
//struct GoldenCardSuccessEffectModifier: ViewModifier {
//    let isActive: Bool
//    @State private var particlesOpacity: Double = 0
//    @State private var particles: [(CGPoint, Double)] = []
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay(
//                GeometryReader { geometry in
//                    ForEach(0..<particles.count, id: \.self) { index in
//                        Circle()
//                            .fill(
//                                LinearGradient(
//                                    colors: [.yellow, .orange],
//                                    startPoint: .top,
//                                    endPoint: .bottom
//                                )
//                            )
//                            .frame(width: 8, height: 8)
//                            .position(particles[index].0)
//                            .opacity(particles[index].1)
//                    }
//                }
//                .opacity(particlesOpacity)
//            )
//            .onChange(of: isActive) { newValue in
//                if newValue {
//                    createParticles()
//                    withAnimation(.easeOut(duration: 1)) {
//                        particlesOpacity = 1
//                        updateParticles()
//                    }
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        withAnimation {
//                            particlesOpacity = 0
//                            particles = []
//                        }
//                    }
//                }
//            }
//    }
//    
//    private func createParticles() {
//        particles = (0..<20).map { _ in
//            let randomAngle = Double.random(in: 0..<2 * .pi)
//            let randomRadius = CGFloat.random(in: 50...100)
//            let x = cos(randomAngle) * randomRadius + 200
//            let y = sin(randomAngle) * randomRadius + 200
//            return (CGPoint(x: x, y: y), Double.random(in: 0.5...1))
//        }
//    }
//    
//    private func updateParticles() {
//        for i in particles.indices {
//            let currentPosition = particles[i].0
//            let newX = currentPosition.x + CGFloat.random(in: -50...50)
//            let newY = currentPosition.y - CGFloat.random(in: 50...100)
//            particles[i].0 = CGPoint(x: newX, y: newY)
//            particles[i].1 *= 0.5
//        }
//    }
//}
//
//// MARK: - View Extensions
//extension View {
//    func goldenCard(isGolden: Bool) -> some View {
//        modifier(GoldenCardModifier(isGolden: isGolden))
//    }
//    
//    func goldenCardAppearance(isGolden: Bool) -> some View {
//        modifier(GoldenCardAppearanceModifier(isGolden: isGolden))
//    }
//    
//    func goldenCardSuccessEffect(isActive: Bool) -> some View {
//        modifier(GoldenCardSuccessEffectModifier(isActive: isActive))
//    }
//}
//
