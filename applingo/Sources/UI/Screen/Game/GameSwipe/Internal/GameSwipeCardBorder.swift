import SwiftUI

internal struct GameCardSwipeBorder: View {
    let cornerRadius: CGFloat
    let model: DynamicPatternModel
    let borderWidth: CGFloat = 8.0

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(.clear, lineWidth: borderWidth)
                .background(
                    GameSwipePatternImage(
                        model: model,
                        size: CGSize(width: size.width * 2, height: size.height * 2)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(style: StrokeStyle(lineWidth: borderWidth))
                    )
                )
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(style: StrokeStyle(lineWidth: borderWidth))
                )
        }
        .allowsHitTesting(false)
    }
}
