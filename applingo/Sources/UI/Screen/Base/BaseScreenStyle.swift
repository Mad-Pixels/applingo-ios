import SwiftUI

struct BaseScreenStyle {
    struct UIKitStyle {
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
