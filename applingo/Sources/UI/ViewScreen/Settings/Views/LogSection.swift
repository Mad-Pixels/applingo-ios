import SwiftUI

 struct LogSection: View {
    @ObservedObject private var logHandler = LogHandler.shared
    
    var body: some View {
        AppToggle(
            isOn: $logHandler.sendLogs,
            title: "send_errors_logs",
            header: "log_settings"
        )
    }
}

