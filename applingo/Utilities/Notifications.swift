import Foundation

extension Notification.Name {
    /// Notification posted when visual feedback should be updated.
    /// Observers (e.g., *Game*ViewModel) listen to this notification to update UI elements (such as highlighting answer options)
    /// with the provided parameters in the notification's userInfo (option, color, duration).
    static let visualFeedbackShouldUpdate = Notification.Name("visualFeedbackShouldUpdate")
    
    /// Notification posted when the dictionary list should be updated.
    /// Observers (such as UI components) can refresh their data upon receiving this notification.
    static let dictionaryListShouldUpdate = Notification.Name("dictionaryListShouldUpdate")
    
    /// Notification posted when the word list should be updated.
    /// Observers (such as UI components) can refresh their data upon receiving this notification.
    static let wordListShouldUpdate = Notification.Name("wordListShouldUpdate")
    
    /// Notification posted when text-to-speech has finished speaking.
    static let TTSDidFinishSpeaking = Notification.Name("TTSDidFinishSpeaking")
}
