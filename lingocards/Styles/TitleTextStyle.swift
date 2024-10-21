import SwiftUI

struct TitleTextStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(theme.textColor)
            .padding(.vertical, 5)
    }
}
