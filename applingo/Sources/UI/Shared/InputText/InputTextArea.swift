import SwiftUI

struct InputTextArea: View {
    @Binding var text: String
    let title: String?
    let placeholder: String
    let isEditing: Bool
    let minHeight: CGFloat
    let icon: String?
    let style: InputTextStyle
    
    @FocusState private var isFocused: Bool
    
    init(
        text: Binding<String>,
        title: String? = nil,
        placeholder: String,
        isEditing: Bool = true,
        minHeight: CGFloat = 156,
        icon: String? = nil,
        style: InputTextStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
        self.title = title
        self.placeholder = ""
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
            .stroke(style.borderColor, lineWidth: isFocused ? 6 : 2)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: style.titleSpacing) {
            if let title = title {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(style.titleColor)
            }
            
            HStack(alignment: .top, spacing: style.iconSpacing) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .foregroundColor(style.iconColor)
                        .font(style.textFont)
                        .padding(.top, style.padding.top)
                }
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .focused($isFocused)
                        .disabled(!isEditing)
                        .foregroundColor(style.textColor)
                        .font(style.textFont)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: minHeight)
                        .padding(style.padding)
                    
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(style.placeholderColor)
                            .font(style.textFont)
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
}
