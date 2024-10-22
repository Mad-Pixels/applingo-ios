import SwiftUI

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tabManager: TabManager
    
    @StateObject private var viewModel = TabDictionariesViewModel()
    @StateObject private var errorManager = ErrorManager.shared

    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingFileImporter = false
    @State private var isShowingRemoteList = false
    @State private var isShowingAlert = false

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack {
                    if let error = errorManager.currentError, errorManager.isVisible(for: .dictionaries, source: .getDictionaries) {
                        CompErrorView(errorMessage: error.errorDescription ?? "", theme: theme)
                    }
                    if viewModel.dictionaries.isEmpty && !errorManager.isErrorVisible {
                        CompEmptyListView(
                            theme: theme,
                            message: languageManager.localizedString(for: "NoDictionariesAvailable")
                        )
                    } else {
                        CompDictionaryListView(
                            dictionaries: viewModel.dictionaries,
                            onDictionaryTap: { dictionary in
                                selectedDictionary = dictionary
                            },
                            onDelete: dictionaryDelete,
                            onToggle: { dictionary, newStatus in
                                dictionaryStatusUpdate(dictionary, newStatus: newStatus)
                            },
                            theme: theme
                        )
                    }
                    Spacer()
                }
                .navigationTitle(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenu(
                            items: [
                                CompToolbarMenu.MenuItem(title: languageManager.localizedString(for: "ImportCSV"), systemImage: "tray.and.arrow.down", action: {
                                    isShowingFileImporter = true
                                }),
                                CompToolbarMenu.MenuItem(title: languageManager.localizedString(for: "Download"), systemImage: "arrow.down.circle", action: {
                                    isShowingRemoteList = true
                                })
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    tabManager.setActiveTab(.dictionaries)
                    if tabManager.isActive(tab: .dictionaries) {
                        viewModel.getDictionaries()
                    }
                }
                .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
                    if newTab != .dictionaries {
                        tabManager.deactivateTab(.dictionaries)
                    }
                })
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.tab == .dictionaries, error.source == .deleteDictionary {
                        isShowingAlert = true
                    }
                })
            }
            .alert(isPresented: $isShowingAlert) {
                CompAlertView(
                    title: languageManager.localizedString(for: "Error"),
                    message: errorManager.currentError?.errorDescription ?? "",
                    closeAction: {
                        errorManager.clearError()
                    },
                    theme: theme
                )
            }
            .fileImporter(
                isPresented: $isShowingFileImporter,
                allowedContentTypes: [.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        dictionaryImport(from: url)
                    }
                case .failure(let error):
                    Logger.debug("Failed to import file: \(error)")
                }
            }
            .fullScreenCover(isPresented: $isShowingRemoteList) {
                DictionaryRemoteListView(isPresented: $isShowingRemoteList)
                    .environmentObject(languageManager)
            }
        }
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryDetailView(
                dictionary: dictionary,
                isPresented: .constant(true),
                onSave: { updatedDictionary, completion in
                    viewModel.updateDictionary(updatedDictionary, completion: completion)
                }
            )
        }
    }

    private func dictionaryDelete(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = viewModel.dictionaries[index]
            if dictionary.tableName != "Internal" {
                viewModel.deleteDictionary(dictionary)
            } else {
                let error = AppError(
                    errorType: .ui,
                    errorMessage: languageManager.localizedString(for: "CannotDeleteInternalDictionary"),
                    additionalInfo: nil
                )
                ErrorManager.shared.setError(
                    appError: error,
                    tab: .dictionaries,
                    source: .deleteDictionary
                )
                isShowingAlert = true
            }
        }
    }

    private func dictionaryStatusUpdate(_ dictionary: DictionaryItem, newStatus: Bool) {
        viewModel.updateDictionaryStatus(dictionary.id, newStatus: newStatus) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    return
                case .failure:
                    isShowingAlert = true
                }
            }
        }
    }

    private func dictionaryImport(from url: URL) {
        do {
            try databaseManager.importCSVFile(at: url)
        } catch {
            Logger.debug("Failed to import CSV file: \(error)")
        }
    }
}
