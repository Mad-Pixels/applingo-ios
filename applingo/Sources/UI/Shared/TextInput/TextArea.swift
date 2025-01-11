import SwiftUI

struct TextArea: View {
    @Binding var text: String
    let placeholder: String
    let isEditing: Bool
    let border: Bool
    let minHeight: CGFloat
    let icon: String?
    let style: TextInputStyle
    
    init(
        text: Binding<String>,
        placeholder: String,
        isEditing: Bool = true,
        border: Bool = false,
        minHeight: CGFloat = 156,
        icon: String? = nil,
        style: TextInputStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self.minHeight = minHeight
        self.icon = icon
        self.style = style
    }
    
    var body: some View {
        HStack(alignment: .top) {
            if let iconName = icon {
                Image(systemName: iconName)
                    .foregroundColor(style.iconColor)
                    .font(style.font)
                    .padding(.top, style.padding.top)
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .padding(6)
                    .disabled(!isEditing)
                    .foregroundColor(style.textColor)
                    .font(style.font)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight)
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
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(style.placeholderColor)
                        .font(style.font)
                        .padding(style.padding)
                        .allowsHitTesting(false)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: isEditing)
        }
    }
}
