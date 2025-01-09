import SwiftUI

struct ScreenSettings: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var logHandler = LogHandler.shared
    
    private let style: ScreenSettingsStyle
    
    init(style: ScreenSettingsStyle? = nil) {
        self.style = style ?? .themed(ThemeManager.shared.currentThemeStyle)
    }
    
    var body: some View {
        BaseViewScreen(screen: .settings) {
            Form {
                ThemeSection()
                LocaleSection()
                LogSection()
            }
            .navigationTitle(style.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
