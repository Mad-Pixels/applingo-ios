import SwiftUI

extension View {
    func navigationBarColor(color: Color) -> some View {
        self.modifier(NavigationBarModifier(color: color))
    }
}

struct NavigationBarModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = UIColor(color)
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}
