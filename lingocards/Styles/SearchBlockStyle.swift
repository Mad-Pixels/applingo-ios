import SwiftUI

struct SearchBlockStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .padding()
            .background(theme.backgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.bottom, 10)
    }
}
