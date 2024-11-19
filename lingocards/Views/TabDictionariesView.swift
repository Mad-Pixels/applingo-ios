import SwiftUI
import UniformTypeIdentifiers

struct TabDictionariesView: View {
    @StateObject private var dictionaryAction: DictionaryLocalActionViewModel
    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel

    @State private var selectedDictionary: DictionaryItemModel?
    @State private var isShowingFileImporter = false
    @State private var isShowingInstructions = false
    @State private var isShowingRemoteList = false
    @State private var isShowingAlert = false
    @State private var errorMessage: String = ""

    init() {
        _dictionaryAction = StateObject(wrappedValue: DictionaryLocalActionViewModel())
        _dictionaryGetter = StateObject(wrappedValue: DictionaryLocalGetterViewModel())
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $dictionaryGetter.dictionaries,
                    isLoadingPage: dictionaryGetter.isLoadingPage,
                    error: nil,
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
                .id(ThemeManager.shared.currentTheme)
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
                                CompToolbarMenuView.MenuItem(
                                    title: LanguageManager.shared.localizedString(for: "ImportCSV"),
                                    systemImage: "tray.and.arrow.down",
                                    action: {
                                        isShowingInstructions = true
                                    }
                                ),
                                CompToolbarMenuView.MenuItem(
                                    title: LanguageManager.shared.localizedString(for: "Download"),
                                    systemImage: "arrow.down.circle",
                                    action: {
                                        isShowingRemoteList = true
                                    }
                                )
                            ]
                        )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.tabDictionaries)
                    dictionaryAction.setFrame(.tabDictionaries)
                    dictionaryGetter.setFrame(.tabDictionaries)
                    dictionaryGetter.resetPagination()
                    
                    NotificationCenter.default.addObserver(
                        forName: .dictionaryListShouldUpdate,
                        object: nil,
                        queue: .main
                    ) { [weak dictionaryGetter] _ in
                        dictionaryGetter?.clear()
                        dictionaryGetter?.resetPagination()
                    }
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
                    NotificationCenter.default.removeObserver(
                        self,
                        name: .dictionaryListShouldUpdate,
                        object: nil
                    )
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
            .sheet(isPresented: $isShowingInstructions) {
                CompDictionaryInstructionView(
                    isShowingFileImporter: $isShowingFileImporter,
                    onClose: {
                        isShowingInstructions = false
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
                refresh: {
                    dictionaryGetter.resetPagination()
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
                let appError = AppErrorModel(
                    type: .ui,
                    message: LanguageManager.shared.localizedString(for: "ErrDeleteInternalDictionary"),
                    localized: LanguageManager.shared.localizedString(for: "ErrDeleteInternalDictionary"),
                    original: nil,
                    additional: nil
                )
                ErrorManager.shared.setError(
                    appError: appError,
                    frame: .tabDictionaries,
                    source: .dictionaryDelete
                )
            }
        }
    }

    private func updateStatus(_ dictionary: DictionaryItemModel, newStatus: Bool) {
        guard let dictionaryID = dictionary.id else { return }
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
            let appError = AppErrorModel(
                type: .ui,
                message: LanguageManager.shared.localizedString(for: "ErrFileAccess"),
                localized: LanguageManager.shared.localizedString(for: "ErrFileAccess"),
                original: nil,
                additional: ["url": url.absoluteString]
            )
            ErrorManager.shared.setError(appError: appError, frame: .tabDictionaries, source: .dictionaryImport)
            return
        }

        do {
            let (dictionary, words) = try CSVManager.shared.parse(url: url)
            try CSVManager.shared.saveToDatabase(dictionary: dictionary, words: words)
            dictionaryGetter.resetPagination()
        } catch {
            let appError = AppErrorModel(
                type: .database,
                message: error.localizedDescription,
                localized: LanguageManager.shared.localizedString(for: "ErrImportCSV"),
                original: error,
                additional: ["url": url.absoluteString]
            )
            ErrorManager.shared.setError(appError: appError, frame: .tabDictionaries, source: .dictionaryImport)
        }
    }
}
