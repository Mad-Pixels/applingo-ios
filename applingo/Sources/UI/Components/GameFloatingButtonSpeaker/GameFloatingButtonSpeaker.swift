import SwiftUI

struct GameFloatingButtonSpeaker: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isPlaying: Bool = false
    @State private var observer: NSObjectProtocol?
    
    internal let word: DatabaseModelWord
    internal let disabled: Bool
    
    var body: some View {
        ButtonFloatingSingle(
            icon: "speaker.wave.2",
            action: {
                if !isPlaying {
                    startSpeaking()
                } else {
                    stopSpeaking()
                }
            },
            disabled: disabled
        )
        .waveEffect(
            isActive: isPlaying,
            colors: [
                themeManager.currentThemeStyle.accentPrimary,
                themeManager.currentThemeStyle.accentDark,
                themeManager.currentThemeStyle.accentLight
            ],
            radius: 5
        )
        .onDisappear {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
            stopSpeaking()
        }
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if isPlaying {
                isPlaying = false
            }
        }
    }
    
    private func stopSpeaking() {
        TTS.shared.stop()
        isPlaying = false
    }
}
