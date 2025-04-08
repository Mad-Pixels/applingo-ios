import SwiftUI

internal struct GameSwipeCardBackground: View {
    let cornerRadius: CGFloat
    let model: DynamicPatternModel
    let backgroundScale: CGFloat

    init(
        cornerRadius: CGFloat,
        model: DynamicPatternModel,
        backgroundScale: CGFloat = 2.0
    ) {
        self.cornerRadius = cornerRadius
        self.model = model
        self.backgroundScale = backgroundScale
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            GameSwipePatternImage(
                model: model,
                size: CGSize(width: size.width * backgroundScale, height: size.height * backgroundScale)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .allowsHitTesting(false)
    }
}
