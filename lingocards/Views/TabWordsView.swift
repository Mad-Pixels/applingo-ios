import SwiftUI

struct TabWordsView: View {
    @StateObject private var viewModel = TabWordsViewModel()
    @State private var selectedWord: WordItem?
    @State private var isShowingDetail = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $viewModel.searchText)

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
            .navigationTitle("Words")
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word, isPresented: $isShowingDetail, onSave: viewModel.updateWord)
        }
    }
}


struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text("Search...")
                        .foregroundColor(.gray)
                }
                
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
            }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}


