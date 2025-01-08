import SwiftUI

struct SecondaryIconStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeManager.shared.currentThemeStyle.cardBorder)
    }
}
