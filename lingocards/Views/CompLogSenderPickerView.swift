import SwiftUI

struct CompLogSenderPickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var sendLogs: Bool
    
    var body: some View {
        Section(header: Text(languageManager.localizedString(for: "LogSettings"))) {
            Toggle(isOn: $sendLogs) {
                Text(languageManager.localizedString(for: "SendErrorsLogs").capitalizedFirstLetter)
            }
        }
    }
}
