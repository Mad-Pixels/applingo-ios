import SwiftUI

struct ScreenViewTracker: ViewModifier {
    let screen: DiscoverScreen
    
    func body(content: Content) -> some View {
        content.onAppear {
            AppScreen.shared.setActiveScreen(screen)
        }
    }
}

extension View {
    func withScreenTracker(_ screen: DiscoverScreen) -> some View {
        modifier(ScreenViewTracker(screen: screen))
    }
}
