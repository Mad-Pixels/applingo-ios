import SwiftUI

/// Root for all fields and text areas
struct BaseFieldStyle: ViewModifier {
    let isEditing: Bool
    let border: Bool
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isEditing ? theme.backgroundViewColor : theme.detailsColor)
            )
            .overlay(
                Group {
                    if border {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEditing ? theme.backgroundBlockColor : theme.detailsColor, lineWidth: isEditing ? 2 : 1)
                    }
                }
            )
            .modifier(BaseTextStyle(theme: theme))
            .animation(.easeInOut(duration: 0.4), value: isEditing)
    }
}
