import SwiftUI

/// A view that renders the main background using a collection of words with a parallax effect.
///
/// `MainBackground` displays words from a shared background manager over the entire screen.
/// Each word is rendered with a parallax offset based on device motion, which is processed
/// through a `MotionState` instance. The strength of the parallax effect is determined by a
/// configurable constant.
///
/// The view automatically regenerates its content when it appears and updates the parallax offsets
/// in response to changes in the device's roll and pitch values.
///
struct MainBackground: View {
    @EnvironmentObject private var motionManager: HardwareMotion
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var manager = MainBackgroundManager.shared
    @StateObject private var motionState = MotionState()
    
    // Determines the intensity of the parallax effect, scaling the motion offsets applied to background words.
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
