import SwiftUI

struct BaseScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseScreenStyle
    private let screen: ScreenType
    private let alignment: Alignment
    private let content: Content
    private let title: String?
    
    init(
        screen: ScreenType,
        title: String? = nil,
        style: BaseScreenStyle = .default,
        alignment: Alignment = .top,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
        self.title = title
        self.alignment = alignment
        
        BaseNavigationConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }
    
    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .navigationBarTitleDisplayMode(.inline)
                .customKeyboardToolbar(buttonTitle: "Done")
                .withScreenTracker(screen)
                .withErrorTracker(screen)
                .withLocaleTracker()
                .withThemeTracker()
                .applyTitle(title)
        }
        .onChange(of: themeManager.currentTheme) { _ in
            BaseNavigationConfigurator.configure(
                with: themeManager.currentThemeStyle,
                style: style
            )
        }
    }
}
