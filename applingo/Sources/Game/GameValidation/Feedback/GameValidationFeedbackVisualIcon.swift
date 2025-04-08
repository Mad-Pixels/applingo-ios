import SwiftUI

class GameValidationFeedbackVisualIcon: AbstractGameFeedback {
    private let iconName: String
    private let color: Color
    private let duration: TimeInterval

    init(iconName: String, color: Color, duration: TimeInterval = 0.4) {
        self.iconName = iconName
        self.color = color
        self.duration = duration
    }

    func play(context: FeedbackContext?) {
        let userInfo: [String: Any] = [
            "icon": iconName,
            "color": color,
            "duration": duration
        ]

        NotificationCenter.default.post(
            name: .visualIconFeedbackShouldUpdate,
            object: nil,
            userInfo: userInfo
        )
    }

    func stop() {}
}
