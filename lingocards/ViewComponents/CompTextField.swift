import SwiftUI

/// Main text field component, support:
///  - icons
///  - editable mode
struct CompTextField: View {
    @Binding var text: String

    let placeholder: String
    let isEditing: Bool
    let border: Bool
    let theme: ThemeStyle
    let icon: String?

    init(
        placeholder: String,
        text: Binding<String>,
        isEditing: Bool,
        border: Bool = false,
        theme: ThemeStyle,
        icon: String? = nil
    ) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
        self.theme = theme
        self.icon = icon
    }

    var body: some View {
        HStack {
            if let iconName = icon {
                Image(systemName: iconName)
                    .modifier(SecondaryIconStyle(theme: theme))
            }
            TextField(placeholder, text: $text)
                .disabled(!isEditing)
                .modifier(BaseFieldStyle(isEditing: isEditing, border: border, theme: theme))
        }
    }
}
