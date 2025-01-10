import SwiftUI

struct ScreenSettings: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localeManager: LocaleManager
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
            .id(localeManager.viewId) // Добавляем обновление всей формы
            .navigationTitle(style.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}


struct LocalizedText: View {
    @ObservedObject private var localeManager = LocaleManager.shared
    let key: String
    let arguments: [CVarArg]
    
    init(_ key: String, _ arguments: CVarArg...) {
        self.key = key
        self.arguments = arguments
    }
    
    var body: some View {
        Text(localeManager.localizedString(for: key, arguments: arguments))
            .id(localeManager.viewId)
    }
}
