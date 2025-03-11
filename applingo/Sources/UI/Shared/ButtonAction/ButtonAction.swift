import SwiftUI

/// A customizable button component for actions with consistent theming and style support.
struct ButtonAction: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    let disabled: Bool
    let style: ButtonActionStyle

    // MARK: - Initializer
    /// Initializes a new ButtonAction.
    /// - Parameters:
    ///   - title: The text displayed on the button.
    ///   - action: The closure executed when the button is tapped.
    ///   - disabled: Indicates whether the button is disabled.
    ///   - style: Optional custom style. If nil, the default theme style is used.
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

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            ButtonActionLabel(title: title, style: style)
                .frame(maxWidth: .infinity)
                .frame(height: style.height)
                .background(ButtonActionBackground(style: style))
                .cornerRadius(style.cornerRadius)
                .overlay(ButtonActionBorder(style: style))
                .padding(style.padding)
        }
        .disabled(disabled)
    }
}

/// Displays the button's title text with styling.
private struct ButtonActionLabel: View {
    let title: String
    let style: ButtonActionStyle

    var body: some View {
        DynamicText(
            model: DynamicTextModel(text: title),
            style: style.textStyle
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// Provides an optional background pattern or solid color for the button.
private struct ButtonActionBackground: View {
    let style: ButtonActionStyle

    var body: some View {
        Group {
            if style.patternBackground {
                GeometryReader { geometry in
                    DynamicPattern(
                        model: style.pattern,
                        size: geometry.size
                    )
                    .mask(RoundedRectangle(cornerRadius: style.cornerRadius))
                }
            } else {
                style.backgroundColor
            }
        }
        .allowsHitTesting(false)
    }
}

/// Provides an optional decorative border for the button.
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
        .allowsHitTesting(false)
    }
}
