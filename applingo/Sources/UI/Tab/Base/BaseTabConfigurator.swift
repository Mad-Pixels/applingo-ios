import SwiftUI

struct BaseTabConfigurator {
    static func configure(with theme: AppTheme, style: BaseTabStyle = .default) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Use style-defined background color and blur effect.
        appearance.backgroundColor = UIColor(style.uiKit.backgroundColor(theme))
        appearance.backgroundEffect = UIBlurEffect(style: style.uiKit.blurEffectStyle)
        
        // Configure top border using style-defined border colors.
        let borderColor: UIColor = theme is LightTheme ? style.uiKit.borderColorLight : style.uiKit.borderColorDark
        let borderHeight = style.uiKit.borderHeight
        let borderImage = createTopBorderImage(color: borderColor, height: borderHeight)
        appearance.shadowImage = borderImage
        appearance.shadowColor = .clear
        
        // Apply corner radius and shadow from style.
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.layer.cornerRadius = style.uiKit.cornerRadius
        tabBarAppearance.layer.masksToBounds = true
        tabBarAppearance.layer.shadowColor = style.uiKit.shadowColor.cgColor
        tabBarAppearance.layer.shadowOpacity = style.uiKit.shadowOpacity
        tabBarAppearance.layer.shadowOffset = style.uiKit.shadowOffset
        tabBarAppearance.layer.shadowRadius = style.uiKit.shadowRadius
        
        if #available(iOS 15.0, *) {
            tabBarAppearance.itemPositioning = .automatic
            tabBarAppearance.itemSpacing = style.uiKit.tabBarSpacing
        }
        
        // Normal item appearance.
        let normalAppearance = appearance.stackedLayoutAppearance.normal
        normalAppearance.iconColor = UIColor(style.uiKit.normalIconColor(theme))
        normalAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.normalTitleColor(theme)),
            .font: style.uiKit.titleFont
        ]
        
        // Selected item appearance.
        let selectedAppearance = appearance.stackedLayoutAppearance.selected
        selectedAppearance.iconColor = UIColor(style.uiKit.selectedIconColor(theme))
        selectedAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.selectedTitleColor(theme)),
            .font: style.uiKit.titleFont
        ]
        
        tabBarAppearance.standardAppearance = appearance
        tabBarAppearance.scrollEdgeAppearance = appearance
    }

    /// Creates a resizable image for the top border.
    private static func createTopBorderImage(color: UIColor, height: CGFloat) -> UIImage {
        let size = CGSize(width: 1, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    }
}
