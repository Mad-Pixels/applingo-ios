import SwiftUI

struct DictionaryAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @Binding var isPresented: Bool
    @State private var isShowingRemoteList = false
    @State private var isShowingFileImporter = false
    @State private var selectedFileURL: URL?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    isShowingFileImporter = true
                }) {
                    Text(languageManager.localizedString(for: "ImportCSV"))
                }
                .buttonStyle(ButtonMain())
                .fileImporter(
                    isPresented: $isShowingFileImporter,
                    allowedContentTypes: [.commaSeparatedText],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case .success(let urls):
                        if let url = urls.first {
                            importCSV(from: url)
                        }
                    case .failure(let error):
                        Logger.debug("Failed to import file: \(error)")
                    }
                }

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

    private func importCSV(from url: URL) {
        do {
            try databaseManager.importCSVFile(at: url)
        } catch {
            Logger.debug("Failed to import CSV file: \(error)")
        }
    }
}

