import SwiftUI

struct InputText: View {
    @Binding var text: String
    
    let title: String?
    let placeholder: String
    let isEditing: Bool
    let icon: String?
    let style: InputTextStyle
    
    @FocusState private var isFocused: Bool
    
    /// Initializes the InputText.
    /// - Parameters:
    ///   - text: Binding to the text value.
    ///   - title: Optional title displayed above the text field.
    ///   - placeholder: Placeholder text for the field.
    ///   - isEditing: A flag to enable/disable editing (default is true).
    ///   - icon: Optional SF Symbol name to display.
    ///   - style: The style for the picker. Defaults to themed style using the current theme.
    init(
        text: Binding<String>,
        title: String? = nil,
        placeholder: String,
        isEditing: Bool = true,
        icon: String? = nil,
        style: InputTextStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.title = title
        self.style = style
        self.icon = icon
        
        self._text = text
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
                    .overlay(isEditing ? border : nil)
                    .cornerRadius(style.cornerRadius)
            }
        }
    }
    
    /// Determines the background color based on editing state.
    private var backgroundColor: Color {
        isEditing ? style.backgroundColor : style.disabledBackgroundColor
    }
    
    /// Creates a border view with varying line width depending on focus.
    private var border: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .stroke(style.borderColor, lineWidth: isFocused ? 6 : 2)
    }
}
