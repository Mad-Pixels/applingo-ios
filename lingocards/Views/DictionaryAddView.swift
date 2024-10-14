import SwiftUI

struct DictionaryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var isPresented: Bool
    @State private var isShowingRemoteList = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    importCSV()
                }) {
                    Text(languageManager.localizedString(for: "ImportCSV"))
                }
                .buttonStyle(ButtonMain())

                Button(action: {
                    isShowingRemoteList = true
                }) {
                    Text(languageManager.localizedString(for: "Download"))
                }
                .buttonStyle(ButtonMain())
            }
            .fullScreenCover(isPresented: $isShowingRemoteList) {
                DictionaryRemoteList(isPresented: $isPresented)
                    .ignoresSafeArea()
                    .interactiveDismissDisabled(true)
                    .environmentObject(languageManager)
            }
            .navigationTitle(languageManager.localizedString(for: "AddDictionary").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                isPresented = false  // Закрывает `DictionaryAddView`
            }) {
                Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
            })
            .padding()
        }
    }

    private func importCSV() {
        // Логика для импорта CSV
    }
}
