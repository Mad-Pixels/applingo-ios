import SwiftUI

struct HeaderTextStyle: ViewModifier {
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(theme.textColor)
    }
}
