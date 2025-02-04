import SwiftUI

/// A view that displays a toggle for sending error logs.
struct SettingsFeedbackViewLogger: View {
    
    // MARK: - Environment and Observed Objects
    
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var logHandler = LogHandler.shared
    @StateObject private var locale = SettingsFeedbackLocale()
    let style: SettingsFeedbackStyle
    
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
