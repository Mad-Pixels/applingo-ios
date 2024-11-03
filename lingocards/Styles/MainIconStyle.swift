import SwiftUI

struct MainIconStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeManager.shared.currentThemeStyle.accentColor)
    }
}
