import SwiftUI
import CoreHaptics

struct ShakeEffect: AnimatableModifier {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(x: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)))
    }
}

struct ShakeModifier: ViewModifier {
    let isShaking: Bool
    
    func body(content: Content) -> some View {
        content
            .modifier(ShakeEffect(amount: 12, shakesPerUnit: 4, animatableData: isShaking ? 1 : 0))
            .animation(
                .spring(response: 0.3, dampingFraction: 0.5)
                    .repeatCount(2, autoreverses: false),
                value: isShaking
            )
    }
}

final class HapticManager {
    static let shared = HapticManager()
    private var engine: CHHapticEngine?
    
    private init() {
        setupEngine()
    }
    
    private func setupEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine error: \(error.localizedDescription)")
        }
    }
    
    func playErrorFeedback() {
        // Сначала пробуем UIKit фидбек для простых устройств
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        // Для устройств с поддержкой CHHaptics используем более сложный паттерн
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = engine else { return }
        
        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            
            let event1 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 0
            )
            
            let event2 = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                ],
                relativeTime: 0.1
            )
            
            let pattern = try CHHapticPattern(events: [event1, event2], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Haptic pattern error: \(error.localizedDescription)")
        }
    }
}

extension View {
    func shake(isShaking: Bool) -> some View {
        modifier(ShakeModifier(isShaking: isShaking))
    }
}

protocol GameFeedbackProtocol {
    var isShaking: Bool { get set }
}

// Вместо extension создаем класс для управления состоянием
class GameFeedbackHandler: ObservableObject {
    @Published var isShaking = false
    
    func provideFeedbackForWrongAnswer() {
        // Тактильный отклик
        HapticManager.shared.playErrorFeedback()
        
        // Анимация тряски
        withAnimation(.default) {
            isShaking = true
        }
        
        // Сброс состояния тряски
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.default) {
                self.isShaking = false
            }
        }
    }
}

