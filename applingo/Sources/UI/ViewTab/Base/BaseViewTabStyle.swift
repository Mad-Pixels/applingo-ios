import SwiftUI

struct BaseViewTabStyle {
    struct UIKitStyle {
        // basic
        let fontWeight: UIFont.Weight
        let tabBarSpacing: CGFloat
        let tabBarHeight: CGFloat
        let fontSize: CGFloat
        
        // colors
        let backgroundColor: (ThemeStyle) -> Color
        let normalTitleColor: (ThemeStyle) -> Color
        let normalIconColor: (ThemeStyle) -> Color
        let selectedTitleColor: (ThemeStyle) -> Color
        let selectedIconColor: (ThemeStyle) -> Color
    }
    
    let uiKit: UIKitStyle
}

extension BaseViewTabStyle {
    static var `default`: BaseViewTabStyle {
        BaseViewTabStyle(
            uiKit: UIKitStyle(
                fontWeight: .medium,
                tabBarSpacing: 8,
                tabBarHeight: 49,
                fontSize: 10,
                
                backgroundColor: { theme in
                    theme.backgroundPrimary
                },
                normalTitleColor: { theme in
                    theme.textSecondary
                },
                normalIconColor: { theme in
                    theme.textSecondary
                },
                selectedTitleColor: { theme in
                    theme.accentPrimary
                },
                selectedIconColor: { theme in
                    theme.accentPrimary
                }
            )
        )
    }
}
