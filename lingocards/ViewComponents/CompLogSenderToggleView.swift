import SwiftUI

struct CompLogSenderToggleView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var sendLogs: Bool
    
    let theme: ThemeStyle
    
    var body: some View {
        Section(header: Text(languageManager.localizedString(for: "LogSettings"))
            .modifier(HeaderBlockTextStyle(theme: theme))) {
            
                Toggle(isOn: $sendLogs) {
                    Text(languageManager.localizedString(for: "SendErrorsLogs").capitalizedFirstLetter)
                }
        }
    }
}
