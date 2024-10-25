import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tabManager: TabManager

    @StateObject private var actionViewModel = WordsActionViewModel()
    @StateObject private var wordsGetter = WordsGetterViewModel()
    @StateObject private var errorManager = ErrorManager.shared

    @State private var selectedWord: WordItem?
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    CompSearchView(
                        searchText: $wordsGetter.searchText,
                        placeholder: languageManager.localizedString(for: "Search").capitalizedFirstLetter,
                        theme: theme
                    )
                    .onChange(of: wordsGetter.searchText) { _ in
                        wordsGetter.resetPagination()
                    }

                    if let error = errorManager.currentError, errorManager.isVisible(for: .words, source: .wordsGet) {
                        CompErrorView(errorMessage: error.errorDescription ?? "", theme: theme)
                    }

                    if wordsGetter.words.isEmpty && !errorManager.isErrorVisible {
                        CompEmptyListView(
                            theme: theme,
                            message: languageManager.localizedString(for: "NoWordsAvailable")
                        )
                    } else {
                        CompWordListView(
                            words: wordsGetter.words,
                            onWordTap: { word in
                                isShowingDetailView = true
                                selectedWord = word
                            },
                            onDelete: wordDelete,
                            loadMoreIfNeeded: { word in
                                wordsGetter.loadMoreWordsIfNeeded(currentItem: word)
                            },
                            theme: theme
                        )
                    }
                }
                .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenu(
                            items: [
                                CompToolbarMenu.MenuItem(
                                    title: languageManager.localizedString(for: "AddWord"),
                                    systemImage: "plus.circle",
                                    action: wordAdd
                                )
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    tabManager.setActiveTab(.words)
                    if tabManager.isActive(tab: .words) {
                        wordsGetter.resetPagination()
                    }
                }
                .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
                    if newTab != .learn {
                        tabManager.deactivateTab(.learn)
                    }
                })
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.tab == .words, error.source == .wordDelete {
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
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $isShowingAddView) {
            WordAddView(
                dictionaries: actionViewModel.dictionaries,
                isPresented: $isShowingAddView,
                onSave: { word, completion in
                    actionViewModel.saveWord(word) { result in
                        switch result {
                        case .success:
                            wordsGetter.resetPagination()
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            )
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(
                word: word,
                isPresented: $isShowingDetailView,
                onSave: { updatedWord, completion in
                    actionViewModel.updateWord(updatedWord) { result in
                        switch result {
                        case .success:
                            wordsGetter.resetPagination()
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            )
        }
    }

    private func wordDelete(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = wordsGetter.words[index]
            actionViewModel.deleteWord(word) { result in
                switch result {
                case .success:
                    wordsGetter.words.remove(at: index)
                case .failure(let error):
                    // Обработка ошибки удаления
                    print("Ошибка при удалении слова: \(error)")
                }
            }
        }
    }

    private func wordAdd() {
        actionViewModel.getDictionaries { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isShowingAddView = true
                case .failure(let error):
                    self.isShowingAlert = true
                    if let appError = error as? AppError {
                        ErrorManager.shared.setError(appError: appError, tab: .words, source: .wordAdd)
                    }
                }
            }
        }
    }
}
