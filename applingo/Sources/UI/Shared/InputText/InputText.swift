import SwiftUI

struct InputText: View {
    @Binding var text: String
    let title: String?
    let placeholder: String
    let isEditing: Bool
    let icon: String?
    let style: InputTextStyle
    
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        title: String? = nil,
        placeholder: String,
        isEditing: Bool = true,
        icon: String? = nil,
        style: InputTextStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.icon = icon
        self.style = style
    }
    
    private var backgroundColor: Color {
        isEditing ? style.backgroundColor : style.disabledBackgroundColor
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .stroke(style.borderColor, lineWidth: isFocused ? 6 : 2)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: style.titleSpacing) {
            if let title = title {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
            }
            
            HStack(spacing: style.iconSpacing) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(style.iconColor)
                        .font(style.textFont)
                }
                
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .disabled(!isEditing)
                    .foregroundColor(style.textColor)
                    .font(style.textFont)
                    .textFieldStyle(.plain)
                    .padding(style.padding)
                    .background(backgroundColor)
                    .overlay(
                        isEditing ? border : nil
                    )
                    .cornerRadius(style.cornerRadius)
            }
        }
    }
}
