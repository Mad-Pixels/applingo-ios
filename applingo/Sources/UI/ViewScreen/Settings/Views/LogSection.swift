import SwiftUI

struct LogSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var logHandler = LogHandler.shared
    @Environment(\.settingsLocale) private var locale
    
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
