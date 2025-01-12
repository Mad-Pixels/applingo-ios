import SwiftUI

struct BaseTabStyle {
    struct UIKitStyle {
        // basic
        let fontWeight: UIFont.Weight
        let tabBarSpacing: CGFloat
        let tabBarHeight: CGFloat
        let fontSize: CGFloat
        
        // colors
        let backgroundColor: (AppTheme) -> Color
        let normalTitleColor: (AppTheme) -> Color
        let normalIconColor: (AppTheme) -> Color
        let selectedTitleColor: (AppTheme) -> Color
        let selectedIconColor: (AppTheme) -> Color
    }
    
    let uiKit: UIKitStyle
}

extension BaseTabStyle {
    static var `default`: BaseTabStyle {
        BaseTabStyle(
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
