import SwiftUI

/// Style for icon as secondary object
struct SecondaryIconStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.secondaryIconColor)
    }
}
