import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @StateObject private var viewModel = TabWordsViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false
    @State private var selectedWord: WordItem?
    let theme = ThemeProvider.shared.currentTheme()
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Общий фон

                VStack {
                    // Поисковая строка
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
                        Text(error.errorDescription ?? "")
                            .foregroundColor(.red)
                            .padding()
                            .multilineTextAlignment(.center)
                    }
                    
                    if viewModel.words.isEmpty && !errorManager.isErrorVisible {
                        Spacer()
                        Text(languageManager.localizedString(for: "NoWordsAvailable"))
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.words) { word in
                                HStack {
                                    Text(word.frontText)
                                        .font(.headline)
                                        .foregroundColor(theme.textColor) // Цвет текста по теме
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Image(systemName: "arrow.left.and.right.circle.fill")
                                        .foregroundColor(.blue)
                                    
                                    Text(word.backText)
                                        .font(.headline)
                                        .foregroundColor(theme.textColor) // Цвет текста по теме
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isShowingDetailView = true
                                    selectedWord = word
                                }
                                .onAppear {
                                    viewModel.loadMoreWordsIfNeeded(currentItem: word)
                                }
                            }
                            .onDelete(perform: deleteWord)

                            if viewModel.isLoadingPage {
                                ProgressView()
                                    .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large) // Единый стиль заголовка
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
                
                VStack {
                    Spacer()
                    ButtonFloating(action: {
                        addWord()
                    }, imageName: "plus")
                }
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
    
    private func deleteWord(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = viewModel.words[index]
            viewModel.deleteWord(word)
        }
    }
    
    private func addWord() {
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
