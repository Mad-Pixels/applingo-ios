import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var errorManager = ErrorManager.shared

    @StateObject private var viewModel = TabWordsViewModel()
    @State private var selectedWord: WordItem?
    @State private var isShowingDetail = false

    var body: some View {
        NavigationView {
            VStack {
                CompSearchView(
                    searchText: $viewModel.searchText,
                    placeholder: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                )
                .padding(.bottom, 10)

                // Отображение ошибки, если она есть
                if errorManager.isErrorVisible, let error = errorManager.currentError, error.context == .words {
                    Text(error.errorDescription ?? "")
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                errorManager.isErrorVisible = false
                                errorManager.clearError()
                            }
                        }
                }

                // Отображение списка слов или сообщения, если список пуст
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
                            selectedWord = word
                            isShowingDetail = true
                        }
                    }
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        // Корректная передача аргументов в sheet
        .sheet(item: $selectedWord) { word in
            WordDetailView(
                word: word,
                isPresented: $isShowingDetail,
                onSave: { updatedWord in
                    viewModel.updateWord(updatedWord)
                }
            )
        }
    }
}
