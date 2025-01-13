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
                .background(style.backgroundColor)
                .foregroundColor(style.textColor)
                .cornerRadius(style.cornerRadius)
                .padding(style.padding)
                .font(style.font)
        }
        .disabled(disabled)
    }
}
