import SwiftUI

struct TabWordsView: View {
    @StateObject private var viewModel = TabWordsViewModel()  // Инициализация ViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Добавляем поле поиска
                SearchBarView(searchText: $viewModel.searchText)

                // Отображение списка слов
                List(viewModel.words) { word in
                    HStack {
                        // Front Text (слева)
                        Text(word.frontText)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Иконка со стрелками (по центру)
                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .foregroundColor(.blue)

                        // Back Text (справа)
                        Text(word.backText)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Words")
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
