import SwiftUI

struct BaseScreenStyle {
    struct UIKitStyle {
        // Colors
        let backgroundColor: (AppTheme) -> Color
    }
    
    let uiKit: UIKitStyle
}

extension BaseScreenStyle {
    static var `default`: BaseScreenStyle {
        BaseScreenStyle(
            uiKit: UIKitStyle(
                backgroundColor: { theme in
                    theme.backgroundPrimary
                }
            )
        )
    }
}
