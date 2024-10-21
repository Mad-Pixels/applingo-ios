import SwiftUI

struct FormItemStyle: ViewModifier {
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.textColor)
            .listRowBackground(theme.backgroundColor)
    }
}
