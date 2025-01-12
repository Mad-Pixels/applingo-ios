import SwiftUI

struct ActionButton: View {
    enum ButtonType {
        case action
        case cancel
    }
    
    let title: String
    let type: ButtonType
    let style: ActionButtonStyle
    let action: () -> Void
    
    init(
        title: String,
        type: ButtonType = .action,
        style: ActionButtonStyle? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.style = style ?? .themed(ThemeManager.shared.currentThemeStyle, type: type)
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(style.font)
                .foregroundColor(style.textColor)
                .padding(style.padding)
                .frame(maxWidth: .infinity, minHeight: style.height)
                .background(style.backgroundColor)
                .cornerRadius(style.cornerRadius)
        }
    }
}
