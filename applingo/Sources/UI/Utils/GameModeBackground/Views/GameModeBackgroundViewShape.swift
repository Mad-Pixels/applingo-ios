import SwiftUI

struct GameModeBackgroundViewShape: View {
    let shape: BackgroundShape
    let theme: AppTheme
    let offset: CGPoint
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(theme.accentPrimary.opacity(shape.opacity))
            .frame(width: shape.size, height: shape.size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .offset(x: offset.x, y: offset.y)
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
