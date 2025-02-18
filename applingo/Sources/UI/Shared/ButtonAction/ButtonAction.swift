import SwiftUI

// MARK: - ButtonAction View

/// A customizable button that displays an action title with an optional dynamic pattern background or border.
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
            ButtonActionLabel(title: title, style: style)
        }
        .disabled(disabled)
        .frame(maxWidth: .infinity, minHeight: style.height)
        .background(ButtonActionBackground(style: style))
        .foregroundColor(style.textColor)
        .cornerRadius(style.cornerRadius)
        .overlay(ButtonActionBorder(style: style))
        .padding(style.padding)
    }
}

// MARK: - Private Subviews

/// A view that displays the button's title using a dynamic text component.
private struct ButtonActionLabel: View {
    let title: String
    let style: ButtonActionStyle
    
    var body: some View {
        DynamicText(
            model: DynamicTextModel(text: title),
            style: .buttonAction(ThemeManager.shared.currentThemeStyle)
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// A view that provides the button's background. If the style enables pattern background,
/// it displays an animated dynamic pattern; otherwise, it shows a solid color.
private struct ButtonActionBackground: View {
    let style: ButtonActionStyle
    
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
        .allowsHitTesting(false) // Ensure background doesn't block button touches.
    }
}

/// A view that provides the button's border. If the style enables pattern border,
/// it displays an animated dynamic pattern border; otherwise, it shows a solid stroke.
private struct ButtonActionBorder: View {
    let style: ButtonActionStyle
    
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
        .allowsHitTesting(false) // Ensure border doesn't intercept touch events.
    }
}
