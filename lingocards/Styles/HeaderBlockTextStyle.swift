import SwiftUI

struct HeaderBlockTextStyle: ViewModifier {
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
    }
}
