import SwiftUI

struct SettingsFeedbackViewLogger: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var logHandler = LogHandler.shared
    @StateObject private var locale = SettingsLocale()
    
    var body: some View {
        ItemToggle(
            isOn: $logHandler.sendLogs,
            title: locale.sendErrorLogsTitle,
            header: locale.logSettingsTitle,
            style: .themed(themeManager.currentThemeStyle),
            onChange: { newValue in
                logHandler.sendLogs = newValue
            }
        )
    }
}
