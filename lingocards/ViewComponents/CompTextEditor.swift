import SwiftUI

struct CompTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    let isEditing: Bool
    let border: Bool
    let theme: ThemeStyle

    init(placeholder: String, text: Binding<String>, isEditing: Bool, theme: ThemeStyle, border: Bool = false, minHeight: CGFloat = 156) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
        self.minHeight = minHeight
        self.theme = theme
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(6)
                .disabled(!isEditing)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEditing ? theme.backgroundColor : Color(.systemBackground))
                )
                .overlay(
                    Group {
                        if border {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isEditing ? theme.primaryButtonColor : Color(.systemGray4), lineWidth: isEditing ? 2 : 1)
                        }
                    }
                )
                .frame(minHeight: minHeight)
                .animation(.easeInOut(duration: 0.2), value: isEditing)

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(theme.textColor.opacity(0.5))
                    .padding(EdgeInsets(top: 14, leading: 12, bottom: 0, trailing: 6))
                    .allowsHitTesting(false)
            }
        }
    }
}
