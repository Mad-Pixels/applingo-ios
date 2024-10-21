import SwiftUI

struct CompTextField: View {
    @Binding var text: String

    let placeholder: String
    let isEditing: Bool
    let border: Bool
    let theme: ThemeStyle

    init(placeholder: String, text: Binding<String>, isEditing: Bool, border: Bool = false, theme: ThemeStyle) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
        self.theme = theme
    }

    var body: some View {
        ZStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .disabled(!isEditing)
                .modifier(InputFieldStyle(isEditing: isEditing, border: border, theme: theme))
        }
    }
}
