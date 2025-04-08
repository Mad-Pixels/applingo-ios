import SwiftUI

struct BackgroundMain: View {
    @EnvironmentObject private var motionManager: HardwareMotion
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var manager = BackgroundMainManager.shared
    @StateObject private var motionState = MotionState()
    
    private let parallaxStrength: CGFloat = 70
    
    var body: some View {
        ZStack {
            let words = manager.backgroundWords
            if !words.isEmpty {
                ForEach(words, id: \.id) { word in
                    Text(word.word)
                        .font(Font(word.font))
                        .position(
                            x: word.position.x + motionState.offsetX * parallaxStrength * word.opacity,
                            y: word.position.y + motionState.offsetY * parallaxStrength * word.opacity
                        )
                        .foregroundColor(themeManager.currentThemeStyle.textSecondary.opacity(word.opacity))
                }
            }
        }
        .onAppear {
            manager.generateIfNeeded(for: UIScreen.main.bounds.size)
        }
        .onReceive(motionManager.$roll) { roll in
            motionState.updateMotion(
                roll: roll,
                pitch: motionManager.pitch
            )
        }
        .onReceive(motionManager.$pitch) { pitch in
            motionState.updateMotion(
                roll: motionManager.roll,
                pitch: pitch
            )
        }
    }
}
