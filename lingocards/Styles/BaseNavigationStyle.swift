import SwiftUI

/// Tabs styles
struct BaseNavigationStyle: ViewModifier {
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .toolbarColorScheme(theme is ThemeDark ? .dark : .light, for: .navigationBar)
    }
}
