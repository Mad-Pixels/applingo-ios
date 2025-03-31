import SwiftUI

class HapticFeedback: AbstractGameFeedback {
    private let intensity: Float
    private let sharpness: Float
    private let count: Int
   
    init(intensity: Float = 1.0, sharpness: Float = 0.5, count: Int = 1) {
        self.intensity = intensity
        self.sharpness = sharpness
        self.count = count
    }
   
    func play(context: FeedbackContext? = nil) {
        HardwareHaptic.shared.playHapticPattern(
            intensity: intensity,
            sharpness: sharpness,
            count: count
        )
    }
   
    func stop() {}
}

class CorrectAnswerHapticFeedback: HapticFeedback {
    init() {
        super.init(
            intensity: 0.8,
            sharpness: 0.4,
            count: 1
        )
    }
}

class IncorrectAnswerHapticFeedback: HapticFeedback {
    init() {
        super.init(
            intensity: 1.0,
            sharpness: 0.7,
            count: 2
        )
    }
}
