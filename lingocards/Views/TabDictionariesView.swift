import SwiftUI
import UniformTypeIdentifiers

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var errorManager: ErrorManager

    @StateObject private var dictionaryAction: DictionaryLocalActionViewModel
    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel

    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingFileImporter = false
    @State private var isShowingRemoteList = false
    @State private var isShowingAlert = false

    init() {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let repository = RepositoryDictionary(dbQueue: dbQueue)
        _dictionaryAction = StateObject(wrappedValue: DictionaryLocalActionViewModel(repository: repository))
        _dictionaryGetter = StateObject(wrappedValue: DictionaryLocalGetterViewModel(repository: repository))
    }

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $dictionaryGetter.dictionaries,
                    isLoadingPage: dictionaryGetter.isLoadingPage,
                    error: errorManager.currentError,
                    onItemAppear: { dictionary in
                        dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
                    },
                    onDelete: dictionaryDelete,
                    onItemTap: { dictionary in
                        selectedDictionary = dictionary
                    },
                    emptyListView: AnyView(
                        CompEmptyListView(
                            theme: theme,
                            message: languageManager.localizedString(for: "NoDictionariesAvailable")
                        )
                    ),
                    rowContent: { dictionary in
                        CompDictionaryRowView(
                            dictionary: dictionary,
                            onTap: {
                                selectedDictionary = dictionary
                            },
                            onToggle: { newStatus in
                                dictionaryStatusUpdate(dictionary, newStatus: newStatus)
                            },
                            theme: theme
                        )
                    }
                )
                .searchable(
                    text: $dictionaryGetter.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                )
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
                        dictionaryGetter.resetPagination()
                        dictionaryGetter.get()
                    }
                }
                .onDisappear {
                    dictionaryGetter.clear()
                }
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.tab == .dictionaries, error.source == .dictionaryDelete {
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
                    print("Failed to import file: \(error)")
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
                    dictionaryAction.update(updatedDictionary) { result in
                        switch result {
                        case .success:
                            dictionaryGetter.resetPagination()
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            )
        }
    }

    private func dictionaryDelete(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = dictionaryGetter.dictionaries[index]
            if dictionary.tableName != "Internal" {
                dictionaryAction.delete(dictionary) { result in
                    switch result {
                    case .success:
                        dictionaryGetter.dictionaries.remove(at: index)
                    case .failure(let error):
                        errorManager.setError(
                            appError: AppError(
                                errorType: .database,
                                errorMessage: "Failed to delete dictionary",
                                additionalInfo: ["error": "\(error)"]
                            ),
                            tab: .dictionaries,
                            source: .dictionaryDelete
                        )
                    }
                }
            } else {
                let error = AppError(
                    errorType: .ui,
                    errorMessage: languageManager.localizedString(for: "CannotDeleteInternalDictionary"),
                    additionalInfo: nil
                )
                errorManager.setError(
                    appError: error,
                    tab: .dictionaries,
                    source: .dictionaryDelete
                )
                isShowingAlert = true
            }
        }
    }

    private func dictionaryStatusUpdate(_ dictionary: DictionaryItem, newStatus: Bool) {
        guard let dictionaryID = dictionary.id else {
            print("Error: Dictionary ID is missing.")
            return
        }

        dictionaryAction.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) { result in
            switch result {
            case .success:
                dictionaryGetter.resetPagination()
            case .failure(let error):
                errorManager.setError(
                    appError: AppError(
                        errorType: .database,
                        errorMessage: "Failed to update dictionary status",
                        additionalInfo: ["error": "\(error)"]
                    ),
                    tab: .dictionaries,
                    source: .dictionaryUpdate
                )
            }
        }
    }

    private func dictionaryImport(from url: URL) {
        let success = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }

        guard success else {
            print("Failed to access security scoped resource")
            return
        }

        do {
            try databaseManager.importCSVFile(at: url)
            dictionaryGetter.resetPagination()
            print("Successfully imported CSV file")
        } catch {
            print("Failed to import CSV file: \(error)")
        }
    }
}
