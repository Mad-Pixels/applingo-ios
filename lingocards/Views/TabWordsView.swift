import SwiftUI

struct TabWordsView: View {

    
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
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $wordsGetter.words,
                    isLoadingPage: wordsGetter.isLoadingPage,
                    error: ErrorManager.shared.currentError,
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
                            message: LanguageManager.shared.localizedString(for: "NoWordsAvailable")
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
                    prompt: LanguageManager.shared.localizedString(for: "Search").capitalizedFirstLetter
                )
                .navigationTitle(LanguageManager.shared.localizedString(for: "Words").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenuView(
                            items: [
                                CompToolbarMenuView.MenuItem(
                                    title: LanguageManager.shared.localizedString(for: "AddWord"),
                                    systemImage: "plus.circle",
                                    action: add
                                )
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.tabWords)
                    if FrameManager.shared.isActive(frame: .tabWords) {
                        wordsAction.setFrame(.tabWords)
                        wordsGetter.setFrame(.tabWords)
                        wordsGetter.resetPagination()
                    }
                }
                .onDisappear {
                    wordsGetter.clear()
                }
                .modifier(ErrModifier(currentError: ErrorManager.shared.currentError) { newError in
                    if let error = newError, error.frame == .tabWords, error.source == .wordDelete {
                        isShowingAlert = true
                    }
                })
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(LanguageManager.shared.localizedString(for: "Error")),
                    message: Text(ErrorManager.shared.currentError?.errorDescription ?? ""),
                    dismissButton: .default(Text(LanguageManager.shared.localizedString(for: "Close"))) {
                        ErrorManager.shared.clearError()
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
