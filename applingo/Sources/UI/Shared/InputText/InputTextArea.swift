import SwiftUI

struct InputTextArea: View {
    @Binding var text: String
    let placeholder: String
    let isEditing: Bool
    let minHeight: CGFloat
    let icon: String?
    let style: InputTextStyle
    
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        isEditing: Bool = true,
        minHeight: CGFloat = 156,
        icon: String? = nil,
        style: InputTextStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.minHeight = minHeight
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
        HStack(alignment: .top, spacing: style.iconSpacing) {
            if let iconName = icon {
                Image(systemName: iconName)
                    .foregroundColor(style.iconColor)
                    .font(style.font)
                    .padding(.top, style.padding.top)
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .focused($isFocused)
                    .disabled(!isEditing)
                    .foregroundColor(style.textColor)
                    .font(style.font)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight)
                    .padding(style.padding)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(style.placeholderColor)
                        .font(style.font)
                        .padding(style.padding)
                        .allowsHitTesting(false)
                }
            }
            .background(backgroundColor)
            .overlay(
                isEditing ? border : nil
            )
            .cornerRadius(style.cornerRadius)
        }
    }
}
