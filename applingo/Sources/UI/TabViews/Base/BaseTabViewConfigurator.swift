import SwiftUI

struct BaseTabViewConfigurator {
    static func configure(
        with theme: ThemeStyle,
        style: TabViewBaseStyle = .default
    ) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor(style.uiKit.backgroundColor)
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
        normalAppearance.iconColor = UIColor(style.uiKit.normalIconColor)
        normalAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.normalTitleColor),
            .font: style.uiFont
        ]
        
        // Selected state
        let selectedAppearance = appearance.stackedLayoutAppearance.selected
        selectedAppearance.iconColor = UIColor(style.uiKit.selectedIconColor)
        selectedAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(style.uiKit.selectedTitleColor),
            .font: style.uiFont
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
