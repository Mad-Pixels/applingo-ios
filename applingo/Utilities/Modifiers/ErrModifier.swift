import SwiftUI

struct ErrModifier: ViewModifier {
    let currentError: GlobalError?
    let onChange: (GlobalError?) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: currentError) { oldValue, newValue in
                if oldValue != newValue {
                    onChange(newValue)
                }
            }
        } else {
            content.onChange(of: currentError) { newValue in
                onChange(newValue)
            }
        }
    }
}
