import SwiftUI

struct BaseSearchStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(ThemeManager.shared.currentThemeStyle.backgroundSecondary)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
