import SwiftUI

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    let isEditing: Bool
    let border: Bool
    
    init(placeholder: String, text: Binding<String>, isEditing: Bool, border: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.isEditing = isEditing
        self.border = border
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(.horizontal, 6)
            }

            TextField("", text: $text)
                .disabled(!isEditing)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEditing ? Color(.secondarySystemBackground) : Color(.systemBackground))
                )
                .overlay(
                    Group {
                        if border {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isEditing ? Color.accentColor : Color(.systemGray4), lineWidth: isEditing ? 2 : 1)
                        }
                    }
                )
                .animation(.easeInOut(duration: 0.2), value: isEditing)
        }
    }
}

struct AppTextEditor: View {
    let placeholder: String
    @Binding var text: String
    let isEditing: Bool
    let border: Bool
    
    init(placeholder: String, text: Binding<String>, isEditing: Bool, border: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.isEditing = isEditing
        self.border = border
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 0, trailing: 6))
            }

            TextEditor(text: $text)
                .disabled(!isEditing)
                .scrollContentBackground(.hidden)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isEditing ? Color(.systemBackground) : Color(.secondarySystemBackground))
                )
                .overlay(
                    Group {
                        if border {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isEditing ? Color.accentColor : Color(.systemGray4), lineWidth: isEditing ? 2 : 1)
                        }
                    }
                )
                .frame(minHeight: 100)
                .animation(.easeInOut(duration: 0.2), value: isEditing)
        }
    }
}
