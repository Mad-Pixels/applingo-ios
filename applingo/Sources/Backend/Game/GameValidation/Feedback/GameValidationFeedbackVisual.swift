import SwiftUI

class VisualFeedback: AbstractGameFeedback {
    private let color: Color
    private let duration: TimeInterval
    private var selectedOption: String?
    
    init(color: Color, duration: TimeInterval = 0.7) {
        self.color = color
        self.duration = duration
    }
    
    func setOption(_ option: String) {
        self.selectedOption = option
    }
    
    func play() {
        guard let option = selectedOption else {
            Logger.warning("[VisualFeedback]: Attempting to play without a selected option")
            return
        }
        
        let userInfo: [String: Any] = [
            "option": option,
            "color": color,
            "duration": duration
        ]
        
        NotificationCenter.default.post(
            name: .visualFeedbackShouldUpdate,
            object: nil,
            userInfo: userInfo
        )
    }
    
    func stop() {}
}

class IncorrectAnswerVisualFeedback: VisualFeedback {
    init() {
        super.init(
            color: .red.opacity(0.3),
            duration: 0.8
        )
    }
}
