import SwiftUI

struct CustomButtonStyle: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager

    func body(content: Content) -> some View {
        content
            .padding()
            //.background(themeManager.currentTheme.primaryButtonColor)
            //.foregroundColor(themeManager.currentTheme.textColor)
            .cornerRadius(8)
    }
}

extension View {
    func applyCustomButtonStyle() -> some View {
        self.modifier(CustomButtonStyle())
    }
}
