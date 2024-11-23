import SwiftUI

struct CompTextFieldView: View {
    @Binding var text: String

    let placeholder: String
    let isEditing: Bool
    let border: Bool
    let icon: String?

    init(
        placeholder: String,
        text: Binding<String>,
        isEditing: Bool,
        border: Bool = false,
        icon: String? = nil
    ) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
        self.icon = icon
    }

    var body: some View {
        HStack {
            if let iconName = icon {
                Image(systemName: iconName)
                    .modifier(SecondaryIconStyle())
            }
            TextField(placeholder, text: $text)
                .disabled(!isEditing)
                .modifier(BaseFieldStyle(isEditing: isEditing, border: border))
        }
    }
}
