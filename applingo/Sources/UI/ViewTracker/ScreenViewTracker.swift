import SwiftUI

struct ScreenViewTracker: ViewModifier {
    let screen: ScreenType
    
    func body(content: Content) -> some View {
        content.onAppear {
            AppScreen.shared.setActiveScreen(screen)
        }
    }
}

extension View {
    func withScreenTracker(_ screen: ScreenType) -> some View {
        modifier(ScreenViewTracker(screen: screen))
    }
}
