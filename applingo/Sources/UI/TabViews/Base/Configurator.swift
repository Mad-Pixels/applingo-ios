import SwiftUI

struct TabViewsBaseConfigurator {
    static func configure(with theme: ThemeStyle) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Base state
        appearance.backgroundColor = UIColor(theme.backgroundViewColor)
        appearance.shadowColor = .clear
        
        // Normal state
        let normalAppearance = appearance.stackedLayoutAppearance.normal
        normalAppearance.iconColor = UIColor(theme.secondaryIconColor)
        normalAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.secondaryTextColor),
            .font: UIFont.systemFont(ofSize: 10)
        ]
        
        // Selected state
        let selectedAppearance = appearance.stackedLayoutAppearance.selected
        selectedAppearance.iconColor = UIColor(theme.accentColor)
        selectedAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accentColor),
            .font: UIFont.systemFont(ofSize: 10)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
