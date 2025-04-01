import SwiftUI

struct ButtonFloatingSpeaker: View {
    let word: DatabaseModelWord
    var iconColor: Color = .white
    var backgroundColor: Color = .blue
    
    @State private var isPlaying: Bool = false
    @State private var observer: NSObjectProtocol?
    
    var body: some View {
        ButtonFloatingSingle(
            icon: "speaker.wave.2",
            action: {
                if !isPlaying {
                    startSpeaking()
                }
            }
        )
    }
    
    private func startSpeaking() {
        isPlaying = true
        
        TTS.shared.speak(
            word.backText,
            languageCode: word.backTextCode
        )
        
        observer = NotificationCenter.default.addObserver(
            forName: .TTSDidFinishSpeaking,
            object: nil,
            queue: .main
        ) { _ in
            self.isPlaying = false
        }
    }
}
