import SwiftUI

internal struct GameQuizViewQuestionSpeak: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isPlaying: Bool = false
    @State private var observer: NSObjectProtocol?
    @State private var animationAmount: CGFloat = 1
    
    internal let word: DatabaseModelWord
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            themeManager.currentThemeStyle.accentLight,
                            themeManager.currentThemeStyle.accentPrimary,
                            themeManager.currentThemeStyle.accentDark
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .blur(radius: 4)
                        .offset(x: -3, y: -3)
                        .mask(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                )
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 2)
                        .blur(radius: 4)
                        .offset(x: 3, y: 3)
                        .mask(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                )
                .frame(width: 80, height: 80)
                .shadow(color: themeManager.currentThemeStyle.accentPrimary.opacity(0.5), radius: 10, x: 0, y: 5)
            
            Image("speak")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
            
            if isPlaying {
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(themeManager.currentThemeStyle.accentLight.opacity(0.7 - Double(i) * 0.2), lineWidth: 2)
                        .frame(width: 80 + CGFloat(i * 20) * animationAmount,
                               height: 80 + CGFloat(i * 20) * animationAmount)
                        .scaleEffect(animationAmount)
                        .opacity(Double(3 - i) / 3)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * 0.2),
                            value: animationAmount
                        )
                }
                .onAppear {
                    animationAmount = 1.2
                }
            }
        }
        .onAppear{
            self.startSpeaking()
        }
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
