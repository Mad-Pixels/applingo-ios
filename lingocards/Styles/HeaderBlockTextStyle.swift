import SwiftUI

struct HeaderBlockTextStyle: ViewModifier {
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.headerBlockTextColor)
            .font(.system(size: 14))
            .modifier(BaseTextStyle(theme: theme))
    }
}
