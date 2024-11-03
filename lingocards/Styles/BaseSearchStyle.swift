import SwiftUI

struct BaseSearchStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(ThemeManager().currentThemeStyle.backgroundBlockColor)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
