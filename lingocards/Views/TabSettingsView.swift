import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            Form {
                CompLanguagePickerView(
                    selectedLanguage: $languageManager.currentLanguage,
                    supportedLanguages: languageManager.supportedLanguages,
                    displayName: languageManager.displayName(for:)
                )
            }
            .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
        }
    }
}
