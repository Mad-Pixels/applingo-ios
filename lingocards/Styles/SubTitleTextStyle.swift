import SwiftUI

struct SubtitleTextStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(theme.textColor)
            .padding(.vertical, 2)
    }
}
