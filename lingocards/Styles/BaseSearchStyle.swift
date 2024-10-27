import SwiftUI

struct BaseSearchStyle: ViewModifier {
    let theme: ThemeStyle

    func body(content: Content) -> some View {
        content
            .padding()
            .background(theme.backgroundBlockColor)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
