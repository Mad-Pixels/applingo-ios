import SwiftUI

struct BaseTabView<Content: View>: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let frame: AppFrameModel
    private let content: Content
    
    init(
        frame: AppFrameModel,
        @ViewBuilder content: () -> Content
    ) {
        self.frame = frame
        self.content = content()
        BaseTabViewConfigurator.configure(with: ThemeManager.shared.currentThemeStyle)
    }
    
    var body: some View {
        content
            .withThemeTracker()
            .withFrameTracker(frame)
            .onChange(of: themeManager.currentTheme) { _ in
                BaseTabViewConfigurator.configure(with: themeManager.currentThemeStyle)
            }
    }
}
