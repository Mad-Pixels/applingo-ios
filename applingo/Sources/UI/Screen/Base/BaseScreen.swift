import SwiftUI

struct BaseScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseScreenStyle
    private let screen: ScreenType
    private let content: Content
    private let title: String
    
    init(
        screen: ScreenType,
        title: String,
        style: BaseScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
        self.title = title
        
        BaseNavigationConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }
    
    var body: some View {
        NavigationStack {
            
                content
                    .id("\(themeManager.currentTheme.rawValue)_\(localeManager.viewId)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .withScreenTracker(screen)
            .withErrorTracker(screen)
            .withLocaleTracker()
            .withThemeTracker()
        }
        .onChange(of: themeManager.currentTheme) { _ in
            BaseNavigationConfigurator.configure(
                with: themeManager.currentThemeStyle,
                style: style
            )
        }
    }
}
