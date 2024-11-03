import SwiftUI
import UniformTypeIdentifiers

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var frameManager: FrameManager
    @EnvironmentObject var errorManager: ErrorManager

    @StateObject private var dictionaryAction: DictionaryLocalActionViewModel
    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel

    @State private var selectedDictionary: DictionaryItemModel?
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
                    onDelete: delete,
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
                                updateStatus(dictionary, newStatus: newStatus)
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
                        CompToolbarMenuView(
                            items: [
                                CompToolbarMenuView.MenuItem(title: languageManager.localizedString(for: "ImportCSV"), systemImage: "tray.and.arrow.down", action: {
                                    isShowingFileImporter = true
                                }),
                                CompToolbarMenuView.MenuItem(title: languageManager.localizedString(for: "Download"), systemImage: "arrow.down.circle", action: {
                                    isShowingRemoteList = true
                                })
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.tabDictionaries)
                    print(frameManager.isActive(frame: .tabDictionaries))
                    print(FrameManager.shared.isActive(frame: .tabDictionaries))
                    if FrameManager.shared.isActive(frame: .tabDictionaries) {
                        dictionaryAction.setFrame(.tabDictionaries)
                        dictionaryGetter.setFrame(.tabDictionaries)
                        dictionaryGetter.resetPagination()
                    }
                }
                .onDisappear {
                    dictionaryGetter.clear()
                }
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.frame == .tabDictionaries, error.source == .dictionaryDelete {
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
                if case .success(let urls) = result, let url = urls.first {
                    dictionaryImport(from: url)
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
                        if case .success = result {
                            dictionaryGetter.resetPagination()
                        }
                        completion(result)
                    }
                }
            )
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = dictionaryGetter.dictionaries[index]
            if dictionary.tableName != "Internal" {
                dictionaryAction.delete(dictionary) { result in
                    if case .success = result {
                        dictionaryGetter.dictionaries.remove(at: index)
                    }
                }
            } else {
                let error = AppErrorModel(
                    errorType: .ui,
                    errorMessage: languageManager.localizedString(for: "CannotDeleteInternalDictionary"),
                    additionalInfo: nil
                )
                errorManager.setError(
                    appError: error,
                    frame: .tabDictionaries,
                    source: .dictionaryDelete
                )
                isShowingAlert = true
            }
        }
    }

    private func updateStatus(_ dictionary: DictionaryItemModel, newStatus: Bool) {
        guard let dictionaryID = dictionary.id else {
            return
        }
        dictionaryAction.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) { result in
            if case .success = result {
                dictionaryGetter.resetPagination()
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
