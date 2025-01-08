import SwiftUI

struct BaseViewTabStyle {
    struct UIKitStyle {
        // basic
        let fontWeight: UIFont.Weight
        let tabBarSpacing: CGFloat
        let tabBarHeight: CGFloat
        let fontSize: CGFloat
        
        // default state
        let backgroundColor: (ThemeStyle) -> Color
        let normalTitleColor: (ThemeStyle) -> Color
        let normalIconColor: (ThemeStyle) -> Color
        
        // selected state
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
                    theme.backgroundViewColor
                },
                normalTitleColor: { theme in
                    theme.secondaryTextColor
                },
                normalIconColor: { theme in
                    theme.secondaryIconColor
                },
                
                selectedTitleColor: { theme in
                    theme.accentColor
                },
                selectedIconColor: { theme in
                    theme.accentColor
                }
            )
        )
    }
}

extension BaseViewTabStyle {
    var uiFont: UIFont {
        .systemFont(ofSize: uiKit.fontSize, weight: uiKit.fontWeight)
    }
}
