import SwiftUI

struct DictionaryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @State private var isShowingRemoteList = false
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                importCSV()
            }) {
                Text(languageManager.localizedString(for: "Import CSV").capitalizedFirstLetter)
            }
            .buttonStyle(ButtonMain())

            Button(action: {
                isShowingRemoteList = true
            }) {
                Text(languageManager.localizedString(for: "Download").capitalizedFirstLetter)
            }
            .buttonStyle(ButtonMain())
        }
        .fullScreenCover(isPresented: $isShowingRemoteList) {
            DictionaryRemoteList()
                .ignoresSafeArea()
                .interactiveDismissDisabled(true)
        }
        .navigationTitle(languageManager.localizedString(for: "AddDictionary").capitalizedFirstLetter)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }

    private func importCSV() {
        // Логика для импорта CSV
    }
}
