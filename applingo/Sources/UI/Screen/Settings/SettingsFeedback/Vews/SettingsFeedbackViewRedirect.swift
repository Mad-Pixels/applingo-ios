import SwiftUI

internal struct SettingsFeedbackViewRedirect: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: SettingsFeedbackLocale
    private let style: SettingsFeedbackStyle
    private let title: String
    private let url: String
    
    /// Initializes the SettingsFeedbackViewRedirect.
    /// - Parameters:
    ///   - style: `SettingsFeedbackStyle` object that defines the visual style.
    ///   - locale: `SettingsFeedbackLocale` object that provides localized strings.
    ///   - title: Button title.
    ///   - url: URL for redirect.
    init(
        style: SettingsFeedbackStyle,
        locale: SettingsFeedbackLocale,
        title: String,
        url: String
    ) {
        self.locale = locale
        self.style = style
        self.title = title
        self.url = url
    }
    
    var body: some View {
        ButtonMenu(
            title: title,
            action: {
                guard let url = URL(string: url) else { return }
                UIApplication.shared.open(url)
            },
            style: .external(themeManager.currentThemeStyle)
        )
    }
}
