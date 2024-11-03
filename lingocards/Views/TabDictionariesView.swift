import SwiftUI
import UniformTypeIdentifiers

struct TabDictionariesView: View {
    @StateObject private var dictionaryAction: DictionaryLocalActionViewModel
    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel

    @State private var selectedDictionary: DictionaryItemModel?
    @State private var errorMessage: String = ""
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
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $dictionaryGetter.dictionaries,
                    isLoadingPage: dictionaryGetter.isLoadingPage,
                    error: ErrorManager.shared.currentError,
                    onItemAppear: { dictionary in
                        dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
                    },
                    onDelete: delete,
                    onItemTap: { dictionary in
                        selectedDictionary = dictionary
                    },
                    emptyListView: AnyView(
                        CompEmptyListView(
                            message: LanguageManager.shared.localizedString(for: "NoDictionariesAvailable")
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
                            }
                        )
                    }
                )
                .searchable(
                    text: $dictionaryGetter.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: LanguageManager.shared.localizedString(for: "Search").capitalizedFirstLetter
                )
                .navigationTitle(LanguageManager.shared.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenuView(
                            items: [
                                CompToolbarMenuView.MenuItem(title: LanguageManager.shared.localizedString(
                                    for: "ImportCSV"
                                ), systemImage: "tray.and.arrow.down", action: {
                                    isShowingFileImporter = true
                                }),
                                CompToolbarMenuView.MenuItem(title: LanguageManager.shared.localizedString(
                                    for: "Download"
                                ), systemImage: "arrow.down.circle", action: {
                                    isShowingRemoteList = true
                                })
                            ]
                        )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.tabDictionaries)
                    dictionaryAction.setFrame(.tabDictionaries)
                    dictionaryGetter.setFrame(.tabDictionaries)
                    dictionaryGetter.resetPagination()
                }
                .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
                    if let error = ErrorManager.shared.currentError,
                       error.frame == .tabDictionaries {
                        errorMessage = error.localizedMessage
                        isShowingAlert = true
                    }
                }
                .onDisappear {
                    dictionaryGetter.clear()
                }
                .modifier(ErrModifier(currentError: ErrorManager.shared.currentError) { newError in
                    if let error = newError, error.frame == .tabDictionaries, error.source == .dictionaryDelete {
                        isShowingAlert = true
                    }
                })
            }
            .alert(isPresented: $isShowingAlert) {
                CompAlertView(
                    title: LanguageManager.shared.localizedString(for: "Error"),
                    message: ErrorManager.shared.currentError?.errorDescription ?? "",
                    closeAction: {
                        ErrorManager.shared.clearError()
                    }
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
                    .environmentObject(LanguageManager.shared)
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
                ErrorManager.shared.setError(
                    appError: AppErrorModel(
                        errorType: .ui,
                        errorMessage: LanguageManager.shared.localizedString(for: "CannotDeleteInternalDictionary"),
                        localizedMessage: "asd",
                        additionalInfo: nil
                    ),
                    frame: .tabDictionaries,
                    source: .dictionaryDelete
                )
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
            try DatabaseManager.shared.importCSVFile(at: url)
            dictionaryGetter.resetPagination()
            print("Successfully imported CSV file")
        } catch {
            print("Failed to import CSV file: \(error)")
        }
    }
}
