import Foundation
import Combine

/// A class for localizing TTS error messages.
final class TTSErrorLocale: ObservableObject {
    static let shared = TTSErrorLocale()
    
    @Published var emptyText: String
    @Published var invalidLanguageCode: String
    @Published var voiceNotFound: String
    @Published var audioSessionError: String
    @Published var errorTitle: String
    
    private init() {
        let lm = LocaleManager.shared
        self.emptyText = lm.localizedString(for: "error.tts.emptyText")
        self.invalidLanguageCode = lm.localizedString(for: "error.tts.invalidLanguageCode")
        self.voiceNotFound = lm.localizedString(for: "error.tts.voiceNotFound")
        self.audioSessionError = lm.localizedString(for: "error.tts.audioSessionError")
        self.errorTitle = lm.localizedString(for: "error.tts.title")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: LocaleManager.localeDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func localeDidChange() {
        let lm = LocaleManager.shared
        self.emptyText = lm.localizedString(for: "error.tts.emptyText")
        self.invalidLanguageCode = lm.localizedString(for: "error.tts.invalidLanguageCode")
        self.voiceNotFound = lm.localizedString(for: "error.tts.voiceNotFound")
        self.audioSessionError = lm.localizedString(for: "error.tts.audioSessionError")
        self.errorTitle = lm.localizedString(for: "error.tts.title")
    }
}
