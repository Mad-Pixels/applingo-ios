import SwiftUI

struct ThemeModifier: ViewModifier {
    let selectedTheme: DiscoverTheme
    let onChange: (DiscoverTheme) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: selectedTheme) { oldValue, newValue in
                if oldValue != newValue {
                    onChange(newValue)
                }
            }
        } else {
            content.onChange(of: selectedTheme) { newValue in
                onChange(newValue)
            }
        }
    }
}
