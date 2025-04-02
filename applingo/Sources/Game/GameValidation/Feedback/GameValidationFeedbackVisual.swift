import SwiftUI

class VisualFeedback: AbstractGameFeedback {
    private let selectedColor: Color
    private let correctColor: Color?
    private let duration: TimeInterval
    
    init(selectedColor: Color, correctColor: Color? = nil, duration: TimeInterval = 0.7) {
        self.selectedColor = selectedColor
        self.correctColor = correctColor
        self.duration = duration
    }
    
    func play(context: FeedbackContext?) {
        guard let context = context else {
            Logger.warning("[VisualFeedback]: Attempting to play without context")
            return
        }
        
        sendHighlightNotification(
            option: context.selectedOption,
            color: selectedColor,
            duration: duration
        )
        
        if let correctOption = context.correctOption,
           correctOption != context.selectedOption,
           let correctColor = correctColor {
            sendHighlightNotification(
                option: correctOption,
                color: correctColor,
                duration: duration
            )
        }
        
        if context.customOption != nil {
            sendHighlightNotification(
                option: context.customOption!,
                color: selectedColor,
                duration: duration
            )
        }
    }
    
    private func sendHighlightNotification(option: String, color: Color, duration: TimeInterval) {
        let userInfo: [String: Any] = [
            "duration": duration,
            "option": option,
            "color": color,
        ]
        
        NotificationCenter.default.post(
            name: .visualFeedbackShouldUpdate,
            object: nil,
            userInfo: userInfo
        )
    }
    
    func stop() {}
}

class IncorrectAnswerBackgroundVisualFeedback: VisualFeedback {
    @EnvironmentObject private var themeManager: ThemeManager
    init(theme: GameTheme) {
        super.init(
            selectedColor: theme.incorrect,
            duration: 0.5
        )
    }
}

class CorrectAnswerBackgroundVisualFeedback: VisualFeedback {
    init(theme: GameTheme) {
        super.init(
            selectedColor: theme.correct,
            duration: 0.5
        )
    }
}

class CompleteBackgroundVisualFeedback: VisualFeedback {
    init(theme: GameTheme) {
        super.init(
            selectedColor: theme.incorrect,
            correctColor: theme.correct,
            duration: 0.5
        )
    }
}
