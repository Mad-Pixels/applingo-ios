import SwiftUI

struct KeyboardAdaptive: ViewModifier {
    @State private var offset: CGFloat = 0
    @StateObject private var keyboard = KeyboardObserver()
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onChange(of: keyboard.height) { newValue in
                withAnimation(.easeOut(duration: keyboard.animationDuration)) {
                    offset = newValue
                }
            }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptive())
    }
}
