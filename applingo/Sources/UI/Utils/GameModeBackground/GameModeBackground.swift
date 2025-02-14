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
    // MARK: - State Objects
    /// A shared manager that provides the background shapes.
    @StateObject private var manager = GameModeBackgroundManager.shared
    /// A shared hardware motion manager that provides raw motion data (roll and pitch).
    @StateObject private var motionManager = HardwareMotion.shared
    /// An instance of `MotionState` used to smooth and track motion data.
    @StateObject private var motionState = MotionState()
    
    // MARK: - Private Properties
    /// The strength of the parallax effect; higher values result in more pronounced movement.
    private let parallaxStrength: CGFloat = 180
    
    // MARK: - Input Properties
    /// The array of colors used for generating the background shapes.
    let colors: [Color]
    
    // MARK: - Initializer
    /// Initializes a new `GameModeBackground` view with the specified color palette.
    ///
    /// - Parameter colors: An array of `Color` values used to style the background.
    init(_ colors: [Color]) {
        self.colors = colors
    }
    
    // MARK: - View Body
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
            manager.generateIfNeeded(for: UIScreen.main.bounds.size, using: colors)
        }
        .onChange(of: motionManager.roll) { _ in
            motionState.updateMotion(roll: motionManager.roll, pitch: motionManager.pitch)
        }
        .onChange(of: motionManager.pitch) { _ in
            motionState.updateMotion(roll: motionManager.roll, pitch: motionManager.pitch)
        }
    }
}
