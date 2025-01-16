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
                    SettingsViewTheme()
                        .frame(maxWidth: .infinity)
                    
                    SettingsViewLocale()
                        .frame(maxWidth: .infinity)
                    
                    SettingsViewLogger()
                        .frame(maxWidth: .infinity)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 80)
                }
                .padding(.top, style.padding.top + 8)
                .padding(.leading, style.padding.leading + 8)
                .padding(.trailing, style.padding.trailing + 8)
                .padding(.bottom, style.padding.bottom)
            }
            .background(style.backgroundColor)
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
