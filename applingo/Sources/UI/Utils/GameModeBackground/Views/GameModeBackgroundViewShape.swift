import SwiftUI

struct GameModeBackgroundViewShape: View {
    let shape: BackgroundShape
    let theme: AppTheme
    let offset: CGPoint
   
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.accentPrimary.opacity(0.15))
                .frame(width: shape.size, height: shape.size)
                .blur(radius: shape.size * 0.35)
                .offset(x: 10, y: 10)
           
            Circle()
                .fill(theme.accentPrimary.opacity(shape.opacity * 1.2))
                .frame(width: shape.size, height: shape.size)
                .overlay(
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.4),
                                    .clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: shape.size * 0.8
                            )
                        )
                        .scaleEffect(0.9)
                )

            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: shape.size * 0.3, height: shape.size * 0.3)
                .blur(radius: shape.size * 0.05)
                .offset(x: -shape.size * 0.2, y: -shape.size * 0.2)
        }
        .blur(radius: abs(offset.x + offset.y) * 0.25)
        .rotationEffect(.degrees(
            (offset.x + offset.y) * 2.1
        ))
        .offset(x: offset.x, y: offset.y)
    }
}
