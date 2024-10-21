import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tabManager: TabManager
    
    @StateObject private var viewModel = TabWordsViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    
    @State private var selectedWord: WordItem?
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundColor.edgesIgnoringSafeArea(.all)

                VStack {
                    CompSearchView(
                        searchText: $viewModel.searchText,
                        placeholder: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                    )
                    .padding(.bottom, 10)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.resetPagination()
                        viewModel.getWords()
                    }

                    if let error = errorManager.currentError, errorManager.isVisible(for: .words, source: .getWords) {
                        CompErrorView(errorMessage: error.errorDescription ?? "", theme: theme)
                    }
                    if viewModel.words.isEmpty && !errorManager.isErrorVisible {
                        CompEmptyListView(
                            theme: theme,
                            message: languageManager.localizedString(for: "NoWordsAvailable")
                        )
                    } else {
                        CompWordListView(
                            words: viewModel.words,
                            onWordTap: { word in
                                isShowingDetailView = true
                                selectedWord = word
                            },
                            onDelete: wordDelete,
                            loadMoreIfNeeded: viewModel.loadMoreWordsIfNeeded,
                            theme: theme
                        )
                    }
                }
                .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenu(
                            items: [
                                CompToolbarMenu.MenuItem(title: languageManager.localizedString(for: "AddNewWord"), systemImage: "plus", action: wordAdd)
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    tabManager.setActiveTab(.words)
                    if tabManager.isActive(tab: .words) {
                        viewModel.resetPagination()
                        viewModel.getWords()
                    }
                }
                .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
                    if newTab != .learn {
                        tabManager.deactivateTab(.learn)
                    }
                })
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.tab == .words, error.source == .deleteWord {
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
                dictionaries: viewModel.dictionaries,
                isPresented: $isShowingAddView,
                onSave: { word, completion in
                    viewModel.saveWord(word, completion: completion)
                }
            )
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(
                word: word,
                isPresented: $isShowingDetailView,
                onSave: { updatedWord, completion in
                    viewModel.updateWord(updatedWord, completion: completion)
                }
            )
        }
    }

    private func wordDelete(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = viewModel.words[index]
            viewModel.deleteWord(word)
        }
    }

    private func wordAdd() {
        viewModel.getDictionaries { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isShowingAddView = true
                case .failure(let error):
                    self.isShowingAlert = true
                    if let appError = error as? AppError {
                        ErrorManager.shared.setError(appError: appError, tab: .words, source: .fetchData)
                    }
                }
            }
        }
    }
}
