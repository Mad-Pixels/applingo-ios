import SwiftUI

struct TextInput: View {
    @Binding var text: String
    let placeholder: String
    let isEditing: Bool
    let border: Bool
    let icon: String?
    let style: TextInputStyle
    
    init(
        text: Binding<String>,
        placeholder: String,
        isEditing: Bool = true,
        border: Bool = false,
        icon: String? = nil,
        style: TextInputStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self.icon = icon
        self.style = style
    }
    
    var body: some View {
        HStack {
            if let iconName = icon {
                Image(systemName: iconName)
                    .foregroundColor(style.iconColor)
                    .font(style.font)
            }
            
            TextField(placeholder, text: $text)
                .disabled(!isEditing)
                .foregroundColor(style.textColor)
                .font(style.font)
                .padding(style.padding)
                .background(
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .fill(isEditing ? style.backgroundColor : style.backgroundColor.opacity(0.5))
                )
                .if(border) { view in
                    view.overlay(
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(
                                isEditing ? style.borderColor : style.disabledBorderColor,
                                lineWidth: isEditing ? style.borderWidth : 1
                            )
                    )
                }
        }
    }
}
