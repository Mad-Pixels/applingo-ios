import SwiftUI

// MARK: - InputTextArea View
/// A multi-line text editor with an optional title, icon, and custom styling.
struct InputTextArea: View {
    @Binding var text: String
    let title: String?
    let placeholder: String
    let isEditing: Bool
    let minHeight: CGFloat
    let icon: String?
    let style: InputTextStyle
    
    @FocusState private var isFocused: Bool
    
    /// Initializes the InputTextArea view.
    /// - Parameters:
    ///   - text: Binding to the text value.
    ///   - title: Optional title displayed above the text area.
    ///   - placeholder: Placeholder text displayed when empty.
    ///   - isEditing: A flag to enable/disable editing (default is true).
    ///   - minHeight: Minimum height for the text area.
    ///   - icon: Optional SF Symbol name to display.
    ///   - style: The style for the text area. Defaults to themed style.
    init(
        text: Binding<String>,
        title: String? = nil,
        placeholder: String,
        isEditing: Bool = true,
        minHeight: CGFloat = 35,
        icon: String? = nil,
        style: InputTextStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self._text = text
        self.title = title
        // For text area, we pass an empty string to the TextEditor since
        // the placeholder is handled separately.
        self.placeholder = ""
        self.isEditing = isEditing
        self.minHeight = minHeight
        self.icon = icon
        self.style = style
    }
    
    ///
    private var dynamicHeight: CGFloat {
        if text.isEmpty {
            return minHeight
        }
        
        let containerWidth = UIScreen.main.bounds.width - (style.padding.leading + style.padding.trailing) * 2
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        let constraintRect = CGSize(
            width: containerWidth,
            height: .greatestFiniteMagnitude
        )
        
        let boundingBox = attributedString.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let additionalPadding: CGFloat = 32
        
        let numberOfLines = max(1, boundingBox.height / UIFont.systemFont(ofSize: 14).lineHeight)
        let lineAdjustment = numberOfLines > 1 ? (numberOfLines * 2) : 0
        
        return max(boundingBox.height + additionalPadding + lineAdjustment, minHeight)
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
                        .frame(height: dynamicHeight)
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
                .overlay(isEditing ? border : nil)
                .cornerRadius(style.cornerRadius)
            }
        }
    }
}
