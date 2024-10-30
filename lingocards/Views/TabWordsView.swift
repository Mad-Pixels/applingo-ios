import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var errorManager: ErrorManager

    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel
    @StateObject private var wordsGetter: WordsLocalGetterViewModel
    @StateObject private var wordsAction: WordsLocalActionViewModel

    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false
    @State private var selectedWord: WordItem?

    init() {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }

        let wordRepository = RepositoryWord(dbQueue: dbQueue)
        let dictionaryRepository = RepositoryDictionary(dbQueue: dbQueue)
        _dictionaryGetter = StateObject(wrappedValue: DictionaryLocalGetterViewModel(repository: dictionaryRepository))
        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel(repository: wordRepository))
        _wordsGetter = StateObject(wrappedValue: WordsLocalGetterViewModel(repository: wordRepository))
    }

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    List {
                        if let error = errorManager.currentError, errorManager.isVisible(for: .words, source: .wordsGet) {
                            CompErrorView(errorMessage: error.errorDescription ?? "", theme: theme)
                        }

                        if wordsGetter.words.isEmpty {
                            if wordsGetter.isLoadingPage {
                                // Показываем прелоадер, если идет загрузка и список пуст
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.5)
                                        .padding()
                                    Spacer()
                                }
                            } else {
                                // Показываем CompEmptyListView только если загрузка завершена и список пуст
                                CompEmptyListView(
                                    theme: theme,
                                    message: languageManager.localizedString(for: "NoWordsAvailable")
                                )
                            }
                        } else {
                            // Отображение списка элементов, если данные уже загружены
                            ForEach(wordsGetter.words) { word in
                                CompWordRowView(
                                    word: word,
                                    onTap: {
                                        selectedWord = word
                                        isShowingDetailView = true
                                    },
                                    theme: theme
                                )
                                .onAppear {
                                    wordsGetter.loadMoreWordsIfNeeded(currentItem: word)
                                }
                            }
                            
                            // Прелоадер внизу списка при подгрузке данных
                            if wordsGetter.isLoadingPage {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .padding()
                                    Spacer()
                                }
                            }
                        }
                    }

                    .overlay( // Прелоадер как подложка списка
                        Group {
                            if wordsGetter.isLoadingPage {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5)
                                    .padding()
                            }
                        }, alignment: .center
                    )
                    .searchable(
                        text: $wordsGetter.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                    )
                }
                .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
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
                .onDisappear {
                    dictionaryGetter.clear()
                    wordsGetter.clear()
                }
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.tab == .words, error.source == .wordDelete {
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
                dictionaries: dictionaryGetter.dictionaries,
                isPresented: $isShowingAddView,
                onSave: { word, completion in
                    wordsAction.save(word) { result in
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
                    wordsAction.update(updatedWord) { result in
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

    private func deleteWords(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = wordsGetter.words[index]
            wordDelete(word: word)
        }
    }
    
    private func wordDelete(word: WordItem) {
        wordsAction.delete(word) { result in
            switch result {
            case .success:
                if let index = wordsGetter.words.firstIndex(of: word) {
                    wordsGetter.words.remove(at: index)
                }
            case .failure(let error):
                errorManager.setError(
                    appError: AppError(
                        errorType: .database,
                        errorMessage: "Failed to delete word",
                        additionalInfo: ["error": "\(error)"]
                    ),
                    tab: .words,
                    source: .wordDelete
                )
            }
        }
    }

    private func wordAdd() {
        dictionaryGetter.get()
        isShowingAddView = true
    }
}
