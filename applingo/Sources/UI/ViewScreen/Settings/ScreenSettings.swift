import SwiftUI

struct ScreenSettings: View {
    @StateObject private var style: ScreenSettingsStyle
    
    init(style: ScreenSettingsStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
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
