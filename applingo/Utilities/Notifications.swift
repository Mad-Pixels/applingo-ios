import Foundation

extension Notification.Name {
    /// Notification posted when visual feedback should be updated.
    /// Observers (e.g., *Game*ViewModel) listen to this notification to update UI elements (such as highlighting answer options)
    /// with the provided parameters in the notification's userInfo (option, color, duration).
    static let visualFeedbackShouldUpdate = Notification.Name("visualFeedbackShouldUpdate")
    
    /// Notification posted when an icon-based feedback should be displayed.
    /// Observers listen to this notification to show a feedback icon in the UI,
    /// using the provided parameters in userInfo: `icon` (SF Symbol name), `color` (Color), and `duration` (TimeInterval).
    static let visualIconFeedbackShouldUpdate = Notification.Name("visualIconFeedbackShouldUpdate")
    
    /// Notification posted when the dictionary list should be updated.
    /// Observers (such as UI components) can refresh their data upon receiving this notification.
    static let dictionaryListShouldUpdate = Notification.Name("dictionaryListShouldUpdate")
    
    /// Notification posted when the word list should be updated.
    /// Observers (such as UI components) can refresh their data upon receiving this notification.
    static let wordListShouldUpdate = Notification.Name("wordListShouldUpdate")
    
    /// Notification posted when text-to-speech has finished speaking.
    static let TTSDidFinishSpeaking = Notification.Name("TTSDidFinishSpeaking")
    
    /// Notification posted when automatic speech recognition (ASR) has finished recognizing a user's input.
    /// Used to receive recognition results and continue voice-driven workflows.
    static let ASRDidFinishRecognition = Notification.Name("ASRDidFinishRecognition")
}
