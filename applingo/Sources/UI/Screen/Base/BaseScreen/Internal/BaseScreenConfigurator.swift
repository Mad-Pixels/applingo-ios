import SwiftUI

internal struct BaseNavigationConfigurator {
    static func configure(
        with theme: AppTheme,
        style: BaseScreenStyle = .default
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(theme.backgroundPrimary)
        appearance.shadowColor = .clear
        
        let largeTitleFont = UIFont.systemFont(ofSize: 32, weight: .bold)
        let roundedLargeTitleDescriptor = largeTitleFont.fontDescriptor.withDesign(.rounded)
        let roundedLargeTitle = roundedLargeTitleDescriptor != nil ?
            UIFont(descriptor: roundedLargeTitleDescriptor!, size: 32) : largeTitleFont
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(theme.textPrimary),
            .font: roundedLargeTitle,
            .kern: 0.6
        ]
        
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let roundedTitleDescriptor = titleFont.fontDescriptor.withDesign(.rounded)
        let roundedTitle = roundedTitleDescriptor != nil ?
            UIFont(descriptor: roundedTitleDescriptor!, size: 20) : titleFont
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.textPrimary),
            .font: roundedTitle,
            .kern: 0.4
        ]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
