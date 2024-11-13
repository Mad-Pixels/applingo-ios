import SwiftUI
import CoreHaptics

class CompositeFeedback: ObservableObject {
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
    
    func trigger() {
        isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isActive = false
        }
    }
    
    func modifier() -> ShakeModifier {
        ShakeModifier(duration: duration, isShaking: isActive)
    }
}

struct FeedbackErrorBorder: GameFeedbackVisualProtocol {
    @Binding var isActive: Bool
    
    func trigger() {
        isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isActive = false
        }
    }
    
    func modifier() -> InnerShadowBorderModifier {
        InnerShadowBorderModifier(isActive: isActive, color: .red)
    }
}

struct FeedbackSuccessBorder: GameFeedbackVisualProtocol {
    @Binding var isActive: Bool
    
    func trigger() {
        isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isActive = false
        }
    }
    
    func modifier() -> InnerShadowBorderModifier {
        InnerShadowBorderModifier(isActive: isActive, color: .green)
    }
}

extension View {
    func withFeedback<F: GameFeedbackVisualProtocol>(_ feedback: F) -> some View {
        modifier(feedback.modifier())
    }
}
