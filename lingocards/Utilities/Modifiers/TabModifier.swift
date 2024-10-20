import SwiftUI

struct TabModifier: ViewModifier {
    let activeTab: AppTab
    let onChange: (AppTab) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: activeTab) { oldValue, newValue in
                if oldValue != newValue {
                    onChange(newValue)
                }
            }
        } else {
            content.onChange(of: activeTab) { newValue in
                onChange(newValue)
            }
        }
    }
}
