import SwiftUI

/// A view that displays a toggle for sending error logs.
/// It shows the current state of the log sending option and allows её изменение.
struct SettingsFeedbackViewLogger: View {
    
    // MARK: - Environment and Observed Objects
    
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var logHandler = LogHandler.shared
    /// Uses настройки из SettingsLocale; при необходимости можно использовать отдельный локал для feedback.
    @StateObject private var locale = SettingsLocale()
    
    // MARK: - Body
    
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
