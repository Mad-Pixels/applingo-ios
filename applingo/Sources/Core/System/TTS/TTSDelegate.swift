import AVFoundation
import Foundation

class TTSDelegate: NSObject, AVSpeechSynthesizerDelegate {
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion()
        NotificationCenter.default.post(name: .TTSDidFinishSpeaking, object: nil)
    }
}
