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
    // MARK: - State Objects
    /// A shared manager that provides the background words.
    @StateObject private var manager = MainBackgroundManager.shared
    /// A shared hardware motion manager that provides the raw motion data (roll and pitch).
    @StateObject private var motionManager = HardwareMotion.shared
    /// An instance of `MotionState` that smooths and tracks the motion data.
    @StateObject private var motionState = MotionState()
    
    // MARK: - Private Properties
    /// The strength of the parallax effect applied to the background words.
    private let parallaxStrength: CGFloat = 70
    
    // MARK: - View Body
    var body: some View {
        ZStack {
            let theme = ThemeManager.shared.currentThemeStyle
            let words = manager.backgroundWords
            
            if !words.isEmpty {
                ForEach(words, id: \.id) { word in
                    Text(word.word)
                        .font(Font(word.font))
                        .position(
                            x: word.position.x + motionState.offsetX * parallaxStrength * word.opacity,
                            y: word.position.y + motionState.offsetY * parallaxStrength * word.opacity
                        )
                        .foregroundColor(theme.textSecondary.opacity(word.opacity))
                }
            }
        }
        .onAppear {
            manager.generateIfNeeded(for: UIScreen.main.bounds.size)
        }
        .onChange(of: motionManager.roll) { _ in
            motionState.updateMotion(roll: motionManager.roll, pitch: motionManager.pitch)
        }
        .onChange(of: motionManager.pitch) { _ in
            motionState.updateMotion(roll: motionManager.roll, pitch: motionManager.pitch)
        }
    }
}
