import SwiftUI

struct BaseFieldStyle: ViewModifier {
    let isEditing: Bool
    let border: Bool

    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isEditing ?
                          ThemeManager().currentThemeStyle.backgroundViewColor :
                            ThemeManager().currentThemeStyle.detailsColor)
            )
            .overlay(
                Group {
                    if border {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEditing ?
                                    ThemeManager().currentThemeStyle.backgroundBlockColor :
                                        ThemeManager().currentThemeStyle.detailsColor, lineWidth: isEditing ? 2 : 1)
                    }
                }
            )
            .modifier(BaseTextStyle())
            .animation(.easeInOut(duration: 0.4), value: isEditing)
    }
}
