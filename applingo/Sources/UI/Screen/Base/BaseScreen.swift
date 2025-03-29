import SwiftUI

struct BaseScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseScreenStyle
    private let screen: ScreenType
    private let alignment: Alignment
    private let content: Content
    private let title: String?
    
    /// Initializes the BaseScreen.
    /// - Parameters:
    ///   - screen: The type of screen for tracking and error handling purposes.
    ///   - title: An optional title for the navigation bar.
    ///   - style: The styling to apply to the screen. Defaults to `.default`.
    ///   - alignment: Alignment of the content within the available frame. Defaults to `.top`.
    ///   - content: A view builder closure that defines the content of the screen.
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
            with: themeManager.currentThemeStyle,
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
