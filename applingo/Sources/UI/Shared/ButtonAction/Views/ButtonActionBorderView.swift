import SwiftUI

internal struct ButtonActionBorderView: View {
    internal let style: ButtonActionStyle
    
    var body: some View {
        Group {
            if style.patternBorder {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .strokeBorder(.clear, lineWidth: style.borderWidth)
                        .background(
                            DynamicPattern(
                                model: style.pattern,
                                size: CGSize(width: geometry.size.width * 2, height: geometry.size.height * 2)
                            )
                        )
                        .mask(
                            RoundedRectangle(cornerRadius: style.cornerRadius)
                                .strokeBorder(style: StrokeStyle(lineWidth: style.borderWidth))
                        )
                }
            } else {
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            }
        }
        .allowsHitTesting(false)
    }
}
