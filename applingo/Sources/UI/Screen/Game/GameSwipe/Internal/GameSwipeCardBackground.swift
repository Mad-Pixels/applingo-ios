import SwiftUI

internal struct GameSwipeCardBackground: View {
    let cornerRadius: CGFloat
    let style: AppTheme
    let backgroundScale: CGFloat

    init(
        cornerRadius: CGFloat,
        style: AppTheme,
        backgroundScale: CGFloat = 2.0
    ) {
        self.cornerRadius = cornerRadius
        self.style = style
        self.backgroundScale = backgroundScale
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            GameSwipePatternImage(
                model: style.mainPattern,
                size: CGSize(width: size.width * backgroundScale, height: size.height * backgroundScale)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .allowsHitTesting(false)
    }
}
