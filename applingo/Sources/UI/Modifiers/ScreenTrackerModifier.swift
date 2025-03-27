import SwiftUI

/// A ViewModifier that tracks the active screen by updating a shared AppStorage value when the view appears.
/// This helps in managing the current screen state across the app.
struct ScreenTrackerModifier: ViewModifier {
    let screen: ScreenType
    
    func body(content: Content) -> some View {
        content.onAppear {
            AppStorage.shared.activeScreen = screen
        }
    }
}
