import SwiftUI

struct InputFieldStyle: ViewModifier {
    let isEditing: Bool
    let border: Bool
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isEditing ? theme.secondaryButtonColor : theme.backgroundColor)
            )
            .overlay(
                Group {
                    if border {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEditing ? theme.primaryButtonColor : Color(.systemGray4), lineWidth: isEditing ? 2 : 1)
                    }
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
}
