import SwiftUI

internal struct SettingsFeedbackViewLogger: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var logHandler = LogHandler.shared
    
    private let locale: SettingsFeedbackLocale
    private let style: SettingsFeedbackStyle
    
    /// Initializes the SettingsFeedbackViewLogger.
    /// - Parameters:
    ///   - style: `SettingsFeedbackStyle` object that defines the visual style.
    ///   - locale: `SettingsFeedbackLocale` object that provides localized strings.
    init(
        style: SettingsFeedbackStyle,
        locale: SettingsFeedbackLocale
    ) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        SectionHeader(
            title: locale.screenSubtitleSendLogs,
            style: .block(ThemeManager.shared.currentThemeStyle)
        )
        
        ItemToggle(
            isOn: $logHandler.sendLogs,
            title: locale.screenDescriptionSendLogs,
            
            onChange: { newValue in
                logHandler.sendLogs = newValue
            }
        )
        
        SectionBody(content: {
            DynamicText(
                model: DynamicTextModel(text: locale.screenTextSendLogs),
                style: .textLight(
                    ThemeManager.shared.currentThemeStyle,
                    alignment: .leading,
                    lineLimit: 8
                )
            )
        },
            style: .accent(themeManager.currentThemeStyle)
        )
    }
}
