import SwiftUI

// InputText.swift
struct InputText: View {
    @Binding var text: String
    let placeholder: String
    let isEditing: Bool
    let icon: String?
    let style: InputTextStyle
    
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        isEditing: Bool = true,
        icon: String? = nil,
        style: InputTextStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
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
            .stroke(style.borderColor, lineWidth: isFocused ? 3 : 1)
    }
    
    var body: some View {
        HStack(spacing: style.iconSpacing) {
            if let iconName = icon {
                Image(systemName: iconName)
                    .foregroundColor(style.iconColor)
                    .font(style.font)
            }
            
            TextField(placeholder, text: $text)
                .focused($isFocused)
                .disabled(!isEditing)
                .foregroundColor(style.textColor)
                .font(style.font)
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
