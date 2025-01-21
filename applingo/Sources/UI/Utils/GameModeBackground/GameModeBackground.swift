import SwiftUI

struct GameModeBackground: View {
    @StateObject private var manager = GameModeBackgroundManager.shared
    
    var body: some View {
        ZStack {
            let theme = ThemeManager.shared.currentThemeStyle
            let shapes = manager.backgroundShapes
            
            if !shapes.isEmpty {
                ForEach(shapes, id: \.id) { shape in
                    ShapeView(shape: shape, theme: theme)
                        .position(shape.position)
                }
            }
        }
        .onAppear {
            manager.generateIfNeeded(for: UIScreen.main.bounds.size)
        }
    }
}

private struct ShapeView: View {
    let shape: BackgroundShape
    let theme: AppTheme
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(theme.accentPrimary.opacity(shape.opacity))
            .frame(width: shape.size, height: shape.size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(
                    .linear(duration: Double.random(in: 20...40))
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
    }
}
