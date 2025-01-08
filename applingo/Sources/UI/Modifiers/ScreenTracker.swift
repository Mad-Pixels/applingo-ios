import SwiftUI

struct ScreenTracker: ViewModifier {
    let name: ScreenName
    
    func body(content: Content) -> some View {
        content.onAppear {
            Screen.shared.setActiveScreen(name)
        }
    }
}

extension View {
    func withScreenTracker(_ screenName: ScreenName) -> some View {
        modifier(ScreenTracker(name: screenName))
    }
}
