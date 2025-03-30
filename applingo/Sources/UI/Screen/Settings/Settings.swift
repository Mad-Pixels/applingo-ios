import SwiftUI

struct Settings: View {
    @StateObject private var style: SettingsStyle
    @StateObject private var locale = SettingsLocale()
    
    /// Initializes the WordDetails.
    /// - Parameters:
    ///   - style: Optional style; if nil, a themed style is applied.
    init(style: SettingsStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .Settings,
            title: locale.screenTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    SettingsViewTheme(
                        style: style,
                        locale: locale
                    )
                    
                    SettingsViewLocale(
                        style: style,
                        locale: locale
                    )
                    
                    SettingsViewFeedback(
                        style: style,
                        locale: locale
                    )
                }
                .padding(style.padding)
            }
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
