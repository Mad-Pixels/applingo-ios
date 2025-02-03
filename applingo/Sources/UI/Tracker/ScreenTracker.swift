import SwiftUI

// MARK: - ScreenTracker ViewModifier
/// Tracks the active screen.
struct ScreenTracker: ViewModifier {
    let screen: ScreenType
    
    func body(content: Content) -> some View {
        content.onAppear {
            AppStorage.shared.activeScreen = screen
        }
    }
}

// Extension for easier usage of ScreenTracker
extension View {
    func withScreenTracker(_ screen: ScreenType) -> some View {
        modifier(ScreenTracker(screen: screen))
    }
}
