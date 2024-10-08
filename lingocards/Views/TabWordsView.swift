import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var viewModel = TabWordsViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var selectedWord: WordItem?
    @State private var isShowingDetail = false
    @State private var isShowingAlert = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    CompSearchView(
                        searchText: $viewModel.searchText,
                        placeholder: languageManager.localizedString(for: "Search").capitalizedFirstLetter
                    )
                    .padding(.bottom, 10)

                    if errorManager.isVisible(for: .words, source: .getWords) {
                        Text(errorManager.currentError?.errorDescription ?? "")
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
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                .navigationTitle(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                .onChange(of: errorManager.currentError) { _, newError in
                    if let error = newError, error.context == .words, error.source == .deleteWord {
                        isShowingAlert = true
                    }
                }
                .alert(
                    isPresented: $isShowingAlert,
                    content: {
                        Alert(
                            title: Text(languageManager.localizedString(for: "Error")),
                            message: Text(errorManager.currentError?.errorDescription ?? ""),
                            dismissButton: .default(Text(languageManager.localizedString(for: "Close"))) {
                                errorManager.clearError()
                            }
                        )
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
