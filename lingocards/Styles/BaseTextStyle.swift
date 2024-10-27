import SwiftUI

struct BaseTextStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.baseTextColor)
    }
}
