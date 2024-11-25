import SwiftUI

struct HeaderBlockTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeManager.shared.currentThemeStyle.headerBlockTextColor)
            .font(.system(size: 14))
            .modifier(BaseTextStyle())
    }
}
