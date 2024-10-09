import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @StateObject private var viewModel = TabWordsViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var selectedWord: WordItem?
    @State private var isShowingDetail = false
    @State private var isShowingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                CompSearchView(
                    searchText: $viewModel.searchText,
                    placeholder: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                )
                .padding(.bottom, 10)

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
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Image(systemName: "arrow.left.and.right.circle.fill")
                                    .foregroundColor(.blue)

                                Text(word.backText)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.vertical, 4)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isShowingDetail = true
                                selectedWord = word
                            }
                        }
                        .onDelete(perform: deleteWord)
                    }
                }

                Spacer()
            }
            .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
            .onAppear {
                tabManager.setActiveTab(.words)
                if tabManager.isActive(tab: .words) {
                    viewModel.getWords(search: viewModel.searchText)
                }
            }
            .onChange(of: tabManager.activeTab) { oldTab, newTab in
                if newTab != .words {
                    tabManager.deactivateTab(.words)
                }
            }
            .onChange(of: viewModel.searchText) { _, newSearchText in
                if tabManager.isActive(tab: .words) {
                    viewModel.getWords(search: newSearchText)
                }
            }
            .onChange(of: errorManager.currentError) { _, newError in
                if let error = newError, error.tab == .words, error.source == .deleteWord {
                    isShowingAlert = true
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
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word, isPresented: $isShowingDetail, onSave: viewModel.updateWord)
        }
    }

    private func deleteWord(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = viewModel.words[index]
            viewModel.deleteWord(word)
        }
    }
}
