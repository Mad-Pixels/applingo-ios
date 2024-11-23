import SwiftUI

struct FrameModifier: ViewModifier {
    let activeFrame: AppFrameModel
    let onChange: (AppFrameModel) -> Void
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: activeFrame) { oldValue, newValue in
                if oldValue != newValue {
                    onChange(newValue)
                }
            }
        } else {
            content.onChange(of: activeFrame) { newValue in
                onChange(newValue)
            }
        }
    }
}
