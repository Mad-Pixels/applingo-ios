import SwiftUI

struct CompLanguagePickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedLanguage: String

    var supportedLanguages: [String]
    var displayName: (String) -> String
    
    var body: some View {
        Section(header: Text(languageManager.localizedString(for: "Language").capitalizedFirstLetter)) {
            Picker("Select Language", selection: $selectedLanguage) {
                ForEach(supportedLanguages, id: \.self) { language in
                    Text(displayName(language).capitalizedFirstLetter)
                        .tag(language)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }
}
