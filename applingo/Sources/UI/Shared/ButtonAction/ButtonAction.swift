import SwiftUI

struct ButtonAction: View {
    enum ButtonType {
        case action
        case cancel
        case disabled
    }
    
    let title: String
    let type: ButtonType
    let action: () -> Void
    let style: ButtonActionStyle
    
    init(
        title: String,
        type: ButtonType = .action,
        action: @escaping () -> Void,
        style: ButtonActionStyle? = nil
    ) {
        self.title = title
        self.type = type
        self.action = action
        self.style = style ?? .themed(ThemeManager.shared.currentThemeStyle, type: type)
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
        .disabled(type == .disabled)
    }
}
