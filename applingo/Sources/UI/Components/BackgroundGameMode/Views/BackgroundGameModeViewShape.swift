import SwiftUI

internal struct BackgroundGameModeViewShape: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    internal let shape: BackgroundGameModeModelShape
    internal let offset: CGPoint
    
    var body: some View {
        ZStack {
            Circle()
                .fill(shape.color.opacity(shape.opacity * themeOpacityMultiplier))
                .frame(width: shape.size, height: shape.size)
                .overlay(
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(themeManager.currentTheme == .dark ? 0.2 : 0.1),
                                    .clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: shape.size * 0.8
                            )
                        )
                        .scaleEffect(0.9)
                )
                .blur(radius: blurRadius)
        }
        .rotationEffect(.degrees((offset.x + offset.y) * 1.5))
        .offset(x: offset.x, y: offset.y)
    }
    
    /// Multiplier for opacity based on current theme.
    private var themeOpacityMultiplier: Double {
        themeManager.currentTheme == .dark ? 4.4 : 7.5
    }
    
    /// Blur radius based on current theme.
    private var blurRadius: CGFloat {
        themeManager.currentTheme == .dark ? 12 : 8
    }
}
