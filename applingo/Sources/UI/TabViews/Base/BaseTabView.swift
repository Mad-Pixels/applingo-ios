import SwiftUI

struct BaseTabView<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let frame: AppFrameModel
    private let style: TabViewBaseStyle
    private let content: Content
    
    init(
        frame: AppFrameModel,
        style: TabViewBaseStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.frame = frame
        self.style = style
        self.content = content()
        BaseTabViewConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }
    
    var body: some View {
        content
            .withThemeTracker()
            .withLanguageTracker()
            .withFrameTracker(frame)
            .onChange(of: themeManager.currentTheme) { _ in
                BaseTabViewConfigurator.configure(
                    with: themeManager.currentThemeStyle,
                    style: style
                )
            }
    }
}
