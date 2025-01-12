import SwiftUI

struct BaseTabConfigurator {
    static func configure(
        with theme: AppTheme,
        style: BaseTabStyle = .default
    ) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(style.uiKit.backgroundColor(theme))
        appearance.shadowColor = .clear
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().itemPositioning = .centered
            UITabBar.appearance().itemSpacing = style.uiKit.tabBarSpacing
            
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(
                horizontal: 0,
                vertical: style.uiKit.tabBarSpacing
            )
        }
        
        // Normal state
        let normalAppearance = appearance.stackedLayoutAppearance.normal
        normalAppearance.iconColor = UIColor(style.uiKit.normalIconColor(theme))
        normalAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.normalTitleColor(theme)),
        ]
        
        // Selected state
        let selectedAppearance = appearance.stackedLayoutAppearance.selected
        selectedAppearance.iconColor = UIColor(style.uiKit.selectedIconColor(theme))
        selectedAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.selectedTitleColor(theme)),
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
