import SwiftUI
import CoreHaptics

final class CompositeFeedback: ObservableObject {
    private var feedbacks: [GameFeedbackProtocol]
    
    init(feedbacks: [GameFeedbackProtocol]) {
        self.feedbacks = feedbacks
    }
    
    func trigger() {
        feedbacks.forEach { $0.trigger() }
    }
}

struct FeedbackWrongAnswerHaptic: GameFeedbackHapticProtocol {
    func trigger() {
        playHaptic()
    }
    
    func playHaptic() {
        HapticManager.shared.playHapticPattern(
            intensity: 1.0,
            sharpness: 0.5,
            count: 2
        )
    }
}

struct FeedbackCorrectAnswerHaptic: GameFeedbackHapticProtocol {
    func trigger() {
        playHaptic()
    }
    
    func playHaptic() {
        HapticManager.shared.playHapticPattern(
            intensity: 0.8,
            sharpness: 0.3,
            count: 1
        )
    }
}

struct FeedbackShake: GameFeedbackVisualProtocol {
    @Binding var isActive: Bool
    let duration: Double
    
    init(isActive: Binding<Bool>, duration: Double = 0.5) {
        self._isActive = isActive
        self.duration = duration
    }
    
    func trigger() {
        isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                isActive = false
            }
        }
    }
    
    func modifier() -> ShakeModifier {
        ShakeModifier(isShaking: isActive, duration: duration)
    }
}

struct FeedbackErrorBorder: GameFeedbackVisualProtocol {
    @Binding var isActive: Bool
    let duration: Double
    
    init(isActive: Binding<Bool>, duration: Double = 0.5) {
        self._isActive = isActive
        self.duration = duration
    }
    
    func trigger() {
        isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                isActive = false
            }
        }
    }
    
    func modifier() -> InnerShadowBorderModifier {
        InnerShadowBorderModifier(color: .red, isActive: isActive)
    }
}

struct FeedbackSuccessBorder: GameFeedbackVisualProtocol {
    @Binding var isActive: Bool
    let duration: Double
    
    init(isActive: Binding<Bool>, duration: Double = 0.5) {
        self._isActive = isActive
        self.duration = duration
    }
    
    func trigger() {
        isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                isActive = false
            }
        }
    }
    
    func modifier() -> InnerShadowBorderModifier {
        InnerShadowBorderModifier(color: .green, isActive: isActive)
    }
}

extension View {
    func withVisualFeedback<F: GameFeedbackVisualProtocol>(_ feedback: F) -> some View {
        modifier(feedback.modifier())
    }
    
    func withHapticFeedback(_ feedback: GameFeedbackHapticProtocol) -> some View {
        onAppear {
            feedback.playHaptic()
        }
    }
}

struct GameFeedback {
    static func composite(
        visualFeedbacks: [any GameFeedbackVisualProtocol] = [],
        hapticFeedbacks: [GameFeedbackHapticProtocol] = []
    ) -> CompositeFeedback {
        CompositeFeedback(feedbacks: visualFeedbacks + hapticFeedbacks)
    }
}
