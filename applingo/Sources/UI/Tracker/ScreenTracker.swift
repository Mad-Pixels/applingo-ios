import SwiftUI

struct ScreenTracker: ViewModifier {
   let screen: ScreenType
   
   func body(content: Content) -> some View {
       content.onAppear {
           AppStorage.shared.activeScreen = screen
       }
   }
}

extension View {
   func withScreenTracker(_ screen: ScreenType) -> some View {
       modifier(ScreenTracker(screen: screen))
   }
}
