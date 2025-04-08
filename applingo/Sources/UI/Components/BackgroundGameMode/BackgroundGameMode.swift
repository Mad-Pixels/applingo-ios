import SwiftUI

struct BackgroundGameMode: View {
    @EnvironmentObject private var motionManager: HardwareMotion
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var manager = BackgroundGameModeManager.shared
    @StateObject private var motionState = MotionState()
    
    let colors: [Color]
    
    private let parallaxStrength: CGFloat = 180
    
    var body: some View {
        ZStack {
            let shapes = manager.backgroundShapes
            if !shapes.isEmpty {
                ForEach(shapes, id: \.id) { shape in
                    BackgroundGameModeViewShape(
                        shape: shape,
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
