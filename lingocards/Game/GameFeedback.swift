import SwiftUI
import CoreHaptics

final class CompositeFeedback: ObservableObject {
    var feedbacks: [GameFeedbackProtocol]
    
    init(feedbacks: [GameFeedbackProtocol]) {
        self.feedbacks = feedbacks
    }
    
    func trigger() {
        feedbacks.forEach { $0.trigger() }
    }
    
    func addFeedbacks(_ newFeedbacks: [GameFeedbackProtocol]) {
        feedbacks.append(contentsOf: newFeedbacks)
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

struct GameFeedback {
    static func composite(
        visualFeedbacks: [any GameFeedbackVisualProtocol] = [],
        hapticFeedbacks: [GameFeedbackHapticProtocol] = []
    ) -> CompositeFeedback {
        CompositeFeedback(feedbacks: visualFeedbacks + hapticFeedbacks)
    }
}
