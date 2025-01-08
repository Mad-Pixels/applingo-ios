import SwiftUI

struct BaseTabViewConfigurator {
    static func configure(
        with theme: ThemeStyle,
        style: TabViewBaseStyle = .default
    ) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(theme.backgroundViewColor)
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
        normalAppearance.iconColor = UIColor(theme.secondaryIconColor)
        normalAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.secondaryTextColor),
            .font: style.uiFont
        ]
        
        // Selected state
        let selectedAppearance = appearance.stackedLayoutAppearance.selected
        selectedAppearance.iconColor = UIColor(theme.accentColor)
        selectedAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accentColor),
            .font: style.uiFont
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
