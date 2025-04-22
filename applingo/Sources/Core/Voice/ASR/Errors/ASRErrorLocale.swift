import Foundation
import Combine

/// A class for localizing ASR error messages.
final class ASRErrorLocale: ObservableObject {
    static let shared = ASRErrorLocale()
    
    @Published var audioInputUnavailable: String
    @Published var recognitionFailed: String
    @Published var unsupportedLanguage: String
    @Published var authorizationDenied: String
    @Published var noRecognitionResult: String
    @Published var recordingSessionError: String
    @Published var errorTitle: String
    
    private init() {
        let lm = LocaleManager.shared
        self.audioInputUnavailable = lm.localizedString(for: "error.asr.audioInputUnavailable")
        self.recognitionFailed = lm.localizedString(for: "error.asr.recognitionFailed")
        self.unsupportedLanguage = lm.localizedString(for: "error.asr.unsupportedLanguage")
        self.authorizationDenied = lm.localizedString(for: "error.asr.authorizationDenied")
        self.noRecognitionResult = lm.localizedString(for: "error.asr.noRecognitionResult")
        self.recordingSessionError = lm.localizedString(for: "error.asr.recordingSessionError")
        self.errorTitle = lm.localizedString(for: "error.asr.title")
        
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
        self.audioInputUnavailable = lm.localizedString(for: "error.asr.audioInputUnavailable")
        self.recognitionFailed = lm.localizedString(for: "error.asr.recognitionFailed")
        self.unsupportedLanguage = lm.localizedString(for: "error.asr.unsupportedLanguage")
        self.authorizationDenied = lm.localizedString(for: "error.asr.authorizationDenied")
        self.noRecognitionResult = lm.localizedString(for: "error.asr.noRecognitionResult")
        self.recordingSessionError = lm.localizedString(for: "error.asr.recordingSessionError")
        self.errorTitle = lm.localizedString(for: "error.asr.title")
    }
}
