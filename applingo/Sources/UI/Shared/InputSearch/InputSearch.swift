import SwiftUI

// MARK: - InputSearch View
/// A search input field with a magnifying glass icon, clear button, and custom styling.
struct InputSearch: View {
    @Binding var text: String
    let placeholder: String
    let style: InputSearchStyle
    let isDisabled: Bool
    
    @FocusState private var isFocused: Bool
    
    /// Initializes the InputSearch view.
    /// - Parameters:
    ///   - text: Binding to the search text value.
    ///   - placeholder: Placeholder text displayed when empty.
    ///   - style: The style for the search input. Defaults to themed style.
    ///   - isDisabled: Flag to disable the input. Defaults to false.
    init(
        text: Binding<String>,
        placeholder: String,
        style: InputSearchStyle = .themed(ThemeManager.shared.currentThemeStyle),
        isDisabled: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        HStack(spacing: style.spacing) {
            Image(systemName: isDisabled ? "exclamationmark.magnifyingglass" : "sparkle.magnifyingglass")
                .foregroundColor(isDisabled ? style.disabledIconColor : style.iconColor)
                .font(.system(size: style.iconSize))
            
            TextField(placeholder, text: $text)
                .foregroundColor(isDisabled ? style.disabledTextColor : style.textColor)
                .focused($isFocused)
                .disabled(isDisabled)
                .padding(.vertical, 4)
            
            if !text.isEmpty && !isDisabled {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(style.iconColor)
                        .font(.system(size: style.iconSize))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(style.padding)
        .background(isDisabled ? style.disabledBackgroundColor : Color.clear)
        .cornerRadius(style.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(isDisabled ? style.disabledBorderColor : style.borderColor,
                        lineWidth: isFocused && !isDisabled ? 3 : 1)
        )
        .shadow(color: isDisabled ? .clear : style.shadowColor,
                radius: isDisabled ? 0 : style.shadowRadius,
                x: isDisabled ? 0 : style.shadowX,
                y: isDisabled ? 0 : style.shadowY)
    }
}
