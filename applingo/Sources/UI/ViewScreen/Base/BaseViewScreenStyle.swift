import SwiftUI

struct BaseViewScreenStyle {
    struct UIKitStyle {
        // Colors
        let backgroundColor: (AppTheme) -> Color
    }
    
    let uiKit: UIKitStyle
}

extension BaseViewScreenStyle {
    static var `default`: BaseViewScreenStyle {
        BaseViewScreenStyle(
            uiKit: UIKitStyle(
                backgroundColor: { theme in
                    theme.backgroundPrimary
                }
            )
        )
    }
}
