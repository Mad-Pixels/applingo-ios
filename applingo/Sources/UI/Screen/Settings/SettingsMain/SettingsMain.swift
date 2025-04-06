import SwiftUI

struct SettingsMain: View {
    @StateObject private var style: SettingsMainStyle
    @StateObject private var locale = SettingsMainLocale()
    
    /// Initializes the WordDetails.
    /// - Parameters:
    ///   - style: Optional style; if nil, a themed style is applied.
    init(style: SettingsMainStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .Settings,
            title: locale.screenTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    SettingsMainViewTheme(
                        style: style,
                        locale: locale
                    )
                    
                    SettingsMainViewLocale(
                        style: style,
                        locale: locale
                    )
                    
                    SettingsMainViewFeedback(
                        style: style,
                        locale: locale
                    )
                    
                    SettingsMainViewASRPermissions(
                        style: style,
                        locale: locale
                    )
                }
                .padding(style.padding)
            }
            .padding(.bottom, 128)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
