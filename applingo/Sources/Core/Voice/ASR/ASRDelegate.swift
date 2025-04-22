import Speech
import Foundation

class ASRDelegate: NSObject, SFSpeechRecognizerDelegate {
    private let availabilityChanged: (Bool) -> Void
    
    init(availabilityChanged: @escaping (Bool) -> Void) {
        self.availabilityChanged = availabilityChanged
        super.init()
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        availabilityChanged(available)
    }
}
