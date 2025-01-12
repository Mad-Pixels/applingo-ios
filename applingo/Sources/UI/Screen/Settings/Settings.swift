import SwiftUI

struct Settings: View {
    @StateObject private var style: SettingsStyle
    @StateObject private var locale = SettingsLocale()
    
    init(style: SettingsStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(screen: .settings) {
            Form {
                SettingsViewTheme()
                SettingsViewLocale()
                SettingsViewLogger()
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
