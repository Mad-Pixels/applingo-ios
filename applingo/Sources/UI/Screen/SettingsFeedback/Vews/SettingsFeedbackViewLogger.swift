import SwiftUI

/// A view that displays a toggle for sending error logs.
struct SettingsFeedbackViewLogger: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: SettingsFeedbackLocale
    private let style: SettingsFeedbackStyle
    
    @ObservedObject private var logHandler = LogHandler.shared
    
    // MARK: - Initializer
    /// Initializes the additional view.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    ///   - hint: Binding for the hint text.
    ///   - description: Binding for the description text.
    init(
        style: SettingsFeedbackStyle,
        locale: SettingsFeedbackLocale
    ) {
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        ItemToggle(
            isOn: $logHandler.sendLogs,
            title: locale.screenDescriptionSendLogs,
            header: locale.screenSubtitleSendLogs,
            style: .themed(themeManager.currentThemeStyle),
            onChange: { newValue in
                logHandler.sendLogs = newValue
            }
        )
        
        SectionBody(style: .note(themeManager.currentThemeStyle)) {
            Text(locale.screenTextSendLogs)
                .font(style.font)
                .foregroundColor(style.textColor)
                .frame(maxWidth: .infinity)
        }
        
    }
}
