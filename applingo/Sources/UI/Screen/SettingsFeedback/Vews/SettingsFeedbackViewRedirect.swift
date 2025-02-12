import SwiftUI

struct SettingsFeedbackViewRedirect: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: SettingsFeedbackLocale
    private let style: SettingsFeedbackStyle
    
    private let title: String
    private let url: String
    
    // MARK: - Initializer
    /// Initializes the additional view.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
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
    
    // MARK: - Body
    var body: some View {
        ButtonMenu(
            title: title,
            style: .themed(themeManager.currentThemeStyle),
            action: {
                guard let url = URL(string: url) else { return }
                UIApplication.shared.open(url)
            }
        )
    }
}
