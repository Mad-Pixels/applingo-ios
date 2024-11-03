import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var frameManager: FrameManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var errorManager: ErrorManager

    
    @StateObject private var wordsGetter: WordsLocalGetterViewModel
    @StateObject private var wordsAction: WordsLocalActionViewModel

    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false
    @State private var selectedWord: WordItemModel?

    init() {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }

        let wordRepository = RepositoryWord(dbQueue: dbQueue)
        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel(repository: wordRepository))
        _wordsGetter = StateObject(wrappedValue: WordsLocalGetterViewModel(repository: wordRepository))
    }

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $wordsGetter.words,
                    isLoadingPage: wordsGetter.isLoadingPage,
                    error: errorManager.currentError,
                    onItemAppear: { word in
                        wordsGetter.loadMoreWordsIfNeeded(currentItem: word)
                    },
                    onDelete: delete,
                    onItemTap: { word in
                        selectedWord = word
                        isShowingDetailView = true
                    },
                    emptyListView: AnyView(
                        CompEmptyListView(
                            theme: theme,
                            message: languageManager.localizedString(for: "NoWordsAvailable")
                        )
                    ),
                    rowContent: { word in
                        CompWordRowView(
                            word: word,
                            onTap: {
                                selectedWord = word
                                isShowingDetailView = true
                            },
                            theme: theme
                        )
                    }
                )
                .searchable(
                    text: $wordsGetter.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                )
                .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenuView(
                            items: [
                                CompToolbarMenuView.MenuItem(
                                    title: languageManager.localizedString(for: "AddWord"),
                                    systemImage: "plus.circle",
                                    action: add
                                )
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    frameManager.setActiveFrame(.tabWords)
                    if frameManager.isActive(frame: .tabWords) {
                        wordsAction.setFrame(.tabWords)
                        wordsGetter.setFrame(.tabWords)
                        wordsGetter.resetPagination()
                    }
                }
                .onDisappear {
                    wordsGetter.clear()
                }
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.frame == .tabWords, error.source == .wordDelete {
                        isShowingAlert = true
                    }
                })
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(languageManager.localizedString(for: "Error")),
                    message: Text(errorManager.currentError?.errorDescription ?? ""),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close"))) {
                        errorManager.clearError()
                    }
                )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $isShowingAddView) {
            WordAddView(
                isPresented: $isShowingAddView,
                onSave: { word, completion in
                    wordsAction.save(word) { result in
                        if case .success = result {
                            wordsGetter.resetPagination()
                        }
                        completion(result)
                    }
                }
            )
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(
                word: word,
                isPresented: $isShowingDetailView,
                onSave: { updatedWord, completion in
                    wordsAction.update(updatedWord) { result in
                        if case .success = result {
                            wordsGetter.resetPagination()
                        }
                        completion(result)
                    }
                }
            )
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = wordsGetter.words[index]
            wordsAction.delete(word) { result in
                if case .success = result {
                    if let index = wordsGetter.words.firstIndex(of: word) {
                        wordsGetter.words.remove(at: index)
                    }
                }
            }
        }
    }

    private func add() {
        isShowingAddView = true
    }
}
