import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var viewModel = TabWordsViewModel()
    @StateObject private var errorManager = ErrorManager.shared  // Используем ErrorManager
    @State private var selectedWord: WordItem?
    @State private var isShowingDetail = false

    var body: some View {
        NavigationView {
            VStack {
                // Поисковая строка
                CompSearchView(
                    searchText: $viewModel.searchText,
                    placeholder: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                )
                .padding(.bottom, 12)

                // Отображение ошибки, если она для контекста "words"
                if let error = errorManager.currentError, error.context == .words {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                }

                // Отображение списка или сообщения, если список пуст
                if viewModel.words.isEmpty {
                    Text(languageManager.localizedString(for: "No words available"))
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    List(viewModel.words) { word in
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
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word, isPresented: $isShowingDetail, onSave: viewModel.updateWord)
        }
    }
}
