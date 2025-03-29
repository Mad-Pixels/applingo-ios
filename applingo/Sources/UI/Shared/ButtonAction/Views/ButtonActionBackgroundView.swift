import SwiftUI

internal struct ButtonActionBackgroundView: View {
    internal let style: ButtonActionStyle
    
    var body: some View {
        Group {
            if style.patternBackground {
                GeometryReader { geometry in
                    DynamicPattern(
                        model: style.pattern,
                        size: CGSize(width: geometry.size.width, height: geometry.size.height)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                    )
                }
            } else {
                style.backgroundColor
            }
        }
        .allowsHitTesting(false)
    }
}
