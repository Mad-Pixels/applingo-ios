import SwiftUI

/// Style for icon with accent color
struct MainIconStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.accentColor)
    }
}
