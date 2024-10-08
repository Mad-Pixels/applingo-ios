import SwiftUI

struct AppTextField: View {
    @Binding var text: String
    
    let placeholder: String
    let isEditing: Bool
    let border: Bool
    
    init(placeholder: String, text: Binding<String>, isEditing: Bool, border: Bool = false) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
    }

    var body: some View {
        ZStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .padding(10)
                .textFieldStyle(PlainTextFieldStyle())
                .disabled(!isEditing)
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
    @Binding var text: String
    
    let placeholder: String
    let isEditing: Bool
    let border: Bool
    
    init(placeholder: String, text: Binding<String>, isEditing: Bool, border: Bool = false) {
        self.placeholder = placeholder
        self.isEditing = isEditing
        self.border = border
        self._text = text
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(6)
                .disabled(!isEditing)
                .scrollContentBackground(.hidden)
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
                .frame(minHeight: 100)
                .animation(.easeInOut(duration: 0.2), value: isEditing)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(.placeholderText))
                    .padding(EdgeInsets(top: 14, leading: 12, bottom: 0, trailing: 6))
                    .allowsHitTesting(false)
            }
        }
    }
}
