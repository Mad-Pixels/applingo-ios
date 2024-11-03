import SwiftUI

struct BaseTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
    }
}
