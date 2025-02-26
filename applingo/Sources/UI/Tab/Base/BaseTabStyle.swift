import SwiftUI

// MARK: - BaseTabStyle
/// Defines the styling parameters for base tabs.
struct BaseTabStyle {
    struct UIKitStyle {
        let fontWeight: UIFont.Weight
        let tabBarSpacing: CGFloat
        let tabBarHeight: CGFloat
        let fontSize: CGFloat
        let titleFont: UIFont
        let iconSize: CGFloat

        // Color providers.
        let backgroundColor: (AppTheme) -> Color
        let normalTitleColor: (AppTheme) -> Color
        let normalIconColor: (AppTheme) -> Color
        let selectedTitleColor: (AppTheme) -> Color
        let selectedIconColor: (AppTheme) -> Color
        
        // New style parameters to avoid hardcoded values.
        let cornerRadius: CGFloat
        let shadowColor: UIColor
        let shadowOpacity: Float
        let shadowOffset: CGSize
        let shadowRadius: CGFloat
        
        let borderHeight: CGFloat
        let borderColorLight: UIColor
        let borderColorDark: UIColor
        
        let blurEffectStyle: UIBlurEffect.Style
    }
    
    let uiKit: UIKitStyle
}

extension BaseTabStyle {
    /// Default base tab style.
    static var `default`: BaseTabStyle {
        BaseTabStyle(
            uiKit: BaseTabStyle.UIKitStyle(
                fontWeight: .medium,
                tabBarSpacing: 8,
                tabBarHeight: 49,
                fontSize: 12,
                titleFont: UIFont.systemFont(ofSize: 12, weight: .bold),
                iconSize: 24,
                
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
                },
                
                // New parameters with default values.
                cornerRadius: 16,
                shadowColor: UIColor.black,
                shadowOpacity: 0.1,
                shadowOffset: CGSize(width: 0, height: 2),
                shadowRadius: 4,
                
                borderHeight: 0.5,
                borderColorLight: UIColor.black.withAlphaComponent(0.3),
                borderColorDark: UIColor.white.withAlphaComponent(0.3),
                
                blurEffectStyle: .systemMaterial
            )
        )
    }
}
