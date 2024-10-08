import SwiftUI

struct TabWordsView: View {
    @EnvironmentObject var languageManager: LanguageManager
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
                .padding(.bottom, 12)

                if viewModel.words.isEmpty {
                    VStack {
                        Spacer()
                        Text(languageManager.localizedString(for: "NoWordsAvailable").capitalizedFirstLetter)
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
