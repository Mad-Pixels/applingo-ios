import Foundation
import AVFoundation

class TTS {
    static let shared = TTS()
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            _ = TTSError.audioSessionError(details: error.localizedDescription)
        }
    }
    
    /// Speaks the provided text in the specified language.
    /// - Parameters:
    ///   - text: The text to be spoken.
    ///   - languageCode: The language code (e.g., "ru", "en", "he").
    ///   - rate: The speech rate (default is 0.5).
    ///   - pitch: The pitch multiplier (default is 1.0).
    ///   - completion: An optional closure to be called upon completion.
    func speak(
        _ text: String,
        languageCode: String,
        rate: Float = 0.5,
        pitch: Float = 1.0,
        completion: (() -> Void)? = nil
    ) {
        let ttsCode = TTSLanguageType.shared.get(for: languageCode)
        guard !text.isEmpty || !ttsCode.isEmpty else {
            completion?()
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        
        if let voice = AVSpeechSynthesisVoice(language: ttsCode) {
            utterance.voice = voice
        } else {
            _ = TTSError.voiceNotFound(language: ttsCode)
            completion?()
            return
        }
        
        utterance.pitchMultiplier = pitch
        utterance.volume = 1.0
        utterance.rate = rate
        
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        if let completion = completion {
            let delegate = TTSDelegate(completion: completion)
            utterance.setValue(delegate, forKey: "delegate")
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.speechSynthesizer.speak(utterance)
        }
    }
    
    /// Stops the current speech.
    func stop() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
}

/// Helper class to track speech completion.
private class TTSDelegate: NSObject, AVSpeechSynthesizerDelegate {
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion()
    }
}
