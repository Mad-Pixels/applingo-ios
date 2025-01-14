import SwiftUI

struct BaseNavigationConfigurator {
    static func configure(
        with theme: AppTheme,
        style: BaseScreenStyle = .default
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(theme.backgroundPrimary)
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(theme.textPrimary),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.textPrimary),
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
                    
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
