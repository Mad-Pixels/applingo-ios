import SwiftUI

struct GameModeBackground: View {
    @StateObject private var manager = GameModeBackgroundManager.shared
    @StateObject private var motionManager = HardwareMotion.shared
    
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
                            x: CGFloat(motionManager.roll) * parallaxStrength * (shape.opacity * 2),
                            y: CGFloat(motionManager.pitch) * parallaxStrength * (shape.opacity * 2)
                        )
                    )
                    .position(shape.position)
                }
            }
        }
        .onAppear {
            manager.generateIfNeeded(for: UIScreen.main.bounds.size, using: colors)
        }
    }
}
