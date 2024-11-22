import SwiftUI

struct StatusModifier: ViewModifier {
    let isActive: Bool
    let onChange: (Bool) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: isActive) { oldValue, newValue in
                if oldValue != newValue {
                    onChange(newValue)
                }
            }
        } else {
            content.onChange(of: isActive) { newValue in
                onChange(newValue)
            }
        }
    }
}
