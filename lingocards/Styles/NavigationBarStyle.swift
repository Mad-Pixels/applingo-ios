import SwiftUI

struct NavigationBarStyle: ViewModifier {
    let theme: ThemeStyle
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(theme.navigationBarColor, for: .navigationBar)
            .toolbarColorScheme(theme is ThemeDark ? .dark : .light, for: .navigationBar)
    }
}
