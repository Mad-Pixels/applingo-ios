import SwiftUI

struct MainIconStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeManager().currentThemeStyle.accentColor)
    }
}
