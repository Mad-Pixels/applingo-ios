import SwiftUI

struct BaseTabConfigurator {
    static func configure(
        with theme: AppTheme,
        style: BaseTabStyle = .default
    ) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(style.uiKit.backgroundColor(theme))
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)

        let borderColor: UIColor = {
            switch theme {
            case is LightTheme:
                return UIColor.black.withAlphaComponent(0.3)
            case is DarkTheme:
                return UIColor.white.withAlphaComponent(0.3)
            default:
                return UIColor.black.withAlphaComponent(0.1)
            }
        }()
        let borderHeight: CGFloat = 0.5

        let borderImage = createTopBorderImage(color: borderColor, height: borderHeight)
        appearance.shadowImage = borderImage
        appearance.shadowColor = .clear

        UITabBar.appearance().layer.cornerRadius = 16
        UITabBar.appearance().layer.masksToBounds = true
        UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor
        UITabBar.appearance().layer.shadowOpacity = 0.1
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: 2)
        UITabBar.appearance().layer.shadowRadius = 4
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().itemPositioning = .automatic
            UITabBar.appearance().itemSpacing = style.uiKit.tabBarSpacing
        }

        let normalAppearance = appearance.stackedLayoutAppearance.normal
        normalAppearance.iconColor = UIColor(style.uiKit.normalIconColor(theme))
        normalAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.normalTitleColor(theme)),
            .font: style.uiKit.titleFont
        ]

        let selectedAppearance = appearance.stackedLayoutAppearance.selected
        selectedAppearance.iconColor = UIColor(style.uiKit.selectedIconColor(theme))
        selectedAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.selectedTitleColor(theme)),
            .font: style.uiKit.titleFont
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

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
