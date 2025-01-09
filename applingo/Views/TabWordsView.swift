import SwiftUI

struct TabWordsView: View {
    @StateObject private var wordsGetter: WordsLocalGetterViewModel
    @StateObject private var wordsAction: WordsLocalActionViewModel

    @State private var errorMessage: String = ""
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false
    @State private var selectedWord: WordItemModel?

    init() {
        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel())
        _wordsGetter = StateObject(wrappedValue: WordsLocalGetterViewModel())
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundPrimary.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $wordsGetter.words,
                    isLoadingPage: wordsGetter.isLoadingPage,
                    error: nil,
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
                            message: LanguageManager.shared.localizedString(for: "NoWordsAvailable")
                        )
                    ),
                    rowContent: { word in
                        CompWordRowView(
                            word: word,
                            onTap: {
                                selectedWord = word
                                isShowingDetailView = true
                            }
                        )
                    }
                )
                .id(ThemeManager.shared.currentTheme)
                .background(ThemeManager.shared.currentThemeStyle.backgroundSecondary)
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
                            ]
                        )
                    }
                }
                .onAppear {
                    AppStorage.shared.activeScreen = .words
                    wordsAction.setFrame(.tabWords)
                    wordsGetter.setFrame(.tabWords)
                    wordsGetter.resetPagination()
                }
                .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
                    if let error = ErrorManager1.shared.currentError,
                       error.frame == .tabWords {
                        errorMessage = error.localizedMessage
                        isShowingAlert = true
                    }
                }
                .onDisappear {
                    wordsGetter.clear()
                }
                .modifier(ErrModifier(currentError: ErrorManager1.shared.currentError) { newError in
                    if let error = newError, error.frame == .tabWords, error.source == .wordDelete {
                        isShowingAlert = true
                    }
                })
            }
            .alert(isPresented: $isShowingAlert) {
                CompAlertView(
                    title: LanguageManager.shared.localizedString(for: "Error"),
                    message: ErrorManager1.shared.currentError?.errorDescription ?? "",
                    closeAction: {
                        ErrorManager1.shared.clearError()
                    }
                )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $isShowingAddView) {
            WordAddView(
                isPresented: $isShowingAddView,
                refresh: { wordsGetter.resetPagination() }
            )
        }
        .sheet(item: $selectedWord) { word in
            WordDetailView(
                word: word,
                isPresented: $isShowingDetailView,
                refresh: { wordsGetter.resetPagination() }
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
