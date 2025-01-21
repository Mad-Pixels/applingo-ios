import SwiftUI

struct ButtonAction: View {
    let title: String
    let action: () -> Void
    let disabled: Bool
    let style: ButtonActionStyle

    init(
        title: String,
        action: @escaping () -> Void,
        disabled: Bool = false,
        style: ButtonActionStyle? = nil
    ) {
        self.title = title
        self.action = action
        self.disabled = disabled
        self.style = style ?? .themed(ThemeManager.shared.currentThemeStyle)
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: style.height)
                .background(
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
                )
                .foregroundColor(style.textColor)
                .cornerRadius(style.cornerRadius)
                .overlay(
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
                )
                .padding(style.padding)
                .font(style.font)
        }
        .disabled(disabled)
    }
}
