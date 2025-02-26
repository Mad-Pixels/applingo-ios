import SwiftUI

import SwiftUI

/// A view that renders the background for a game mode using a parallax effect based on device motion.
///
/// `GameModeBackground` displays a collection of shapes (retrieved from a shared manager) over a given
/// color palette. The shapes are offset based on the device's roll and pitch values, creating a dynamic,
/// parallax-like effect. The parallax offset is computed using the current motion state and a configurable
/// strength factor.
///
/// - Parameters:
///   - colors: An array of `Color` values used to generate the background shapes.
struct GameModeBackground: View {
    @StateObject private var manager = GameModeBackgroundManager.shared
    @StateObject private var motionManager = HardwareMotion.shared
    @StateObject private var motionState = MotionState()
    
    private let parallaxStrength: CGFloat = 180
    let colors: [Color]
    
    init(_ colors: [Color]) {
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            let theme = ThemeManager.shared.currentThemeStyle
            let shapes = manager.backgroundShapes
            
            if !shapes.isEmpty {
                ForEach(shapes, id: \.id) { shape in
                    GameModeBackgroundViewShape(
                        shape: shape,
                        theme: theme,
                        offset: CGPoint(
                            x: motionState.offsetX * parallaxStrength * shape.opacity,
                            y: motionState.offsetY * parallaxStrength * shape.opacity
                        )
                    )
                    .position(shape.position)
                }
            }
        }
        .onAppear {
            manager.reset()
            manager.generateIfNeeded(for: UIScreen.main.bounds.size, using: colors)
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
