import SwiftUI

struct AnyViewModifier: ViewModifier {
    let modify: (AnyView) -> AnyView
    
    init<M: ViewModifier>(_ modifier: M) {
        self.modify = { view in
            AnyView(view.modifier(modifier))
        }
    }
    
    func body(content: Content) -> some View {
        modify(AnyView(content))
    }
}
