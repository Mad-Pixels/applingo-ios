import SwiftUI

struct ButtonAction: View {
    let style: ButtonActionStyle
    let disabled: Bool
    let title: String
    let action: () -> Void
    
    /// Initializes the ButtonAction.
    /// - Parameters:
    ///   - title: The text displayed on the button.
    ///   - action: The action executed when the button is tapped.
    ///   - disabled: A Boolean value indicating whether the button is disabled.
    ///   - style: An optional style defining the button appearance. Defaults to the themed action style using the current theme.
    init(
        title: String,
        action: @escaping () -> Void,
        disabled: Bool = false,
        style: ButtonActionStyle = .action(ThemeManager.shared.currentThemeStyle)
    ) {
        self.disabled = disabled
        self.action = action
        self.title = title
        self.style = style
    }
    
    var body: some View {
        Button(action: action) {
            ButtonActionLabelView(title: title, style: style)
        }
        .disabled(disabled)
        .frame(maxWidth: .infinity, minHeight: style.height)
        .background(ButtonActionBackgroundView(style: style))
        .cornerRadius(style.cornerRadius)
        .overlay(ButtonActionBorderView(style: style))
        .padding(style.padding)
    }
}
