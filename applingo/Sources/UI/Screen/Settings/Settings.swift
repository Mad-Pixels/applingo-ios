import SwiftUI

struct Settings: View {
    @StateObject private var style: SettingsStyle
    @StateObject private var locale = SettingsLocale()
    
    init(style: SettingsStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(screen: .settings, title: locale.navigationTitle) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    // Theme Section
                    SettingsViewTheme()
                        .frame(maxWidth: .infinity)
                    
                    // Locale Section
                    SettingsViewLocale()
                        .frame(maxWidth: .infinity)
                    
                    // Logger Section
                    SettingsViewLogger()
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, style.padding.top + 8)
                .padding(.leading, style.padding.leading)
                .padding(.trailing, style.padding.trailing)
                .padding(.bottom, style.padding.bottom)
            }
            .background(style.backgroundColor)
        }
    }
}


