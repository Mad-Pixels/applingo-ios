import SwiftUI

import SwiftUI

struct WordsView: View {
    @StateObject private var viewModel = WordsViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager // Для локализации

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(text: $viewModel.searchText)
                    List {
                        ForEach(viewModel.filteredWords) { word in
                            WordRow(word: word)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    // Показ деталей
                                    viewModel.showWordDetails(word)
                                }
                                .onAppear {
                                    viewModel.loadNextPageIfNeeded(currentItem: word)
                                }
                        }
                        .onDelete(perform: viewModel.deleteWord)
                    }
                }
                .navigationTitle(localizationManager.localizedString(for: "Words"))
                
                // Плавающая кнопка "+"
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.showAddWordForm = true
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(FloatingButtonStyle()) // Применение стиля кнопки
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddWordForm) {
                AddWordFormView(viewModel: viewModel)
            }
            .sheet(item: $viewModel.selectedWord) { word in
                WordDetailView(word: word, viewModel: viewModel)
            }
            .alert(item: $viewModel.activeAlert) { activeAlert in
                // Обработка алертов
                switch activeAlert {
                case .alert(let alertItem):
                    return Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
                case .notify(let notifyItem):
                    return Alert(
                        title: Text(notifyItem.title),
                        message: Text(notifyItem.message),
                        primaryButton: .default(Text("OK"), action: notifyItem.primaryAction),
                        secondaryButton: .cancel(Text("Cancel"), action: notifyItem.secondaryAction ?? {})
                    )
                }
            }
        }
    }
}



// Субпредставления
struct WordRow: View {
    var word: WordItem

    var body: some View {
        HStack {
            Text(word.word)
            Spacer()
            Text(word.definition)
        }
    }
}

struct AddWordFormView: View {
    @ObservedObject var viewModel: WordsViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var wordText: String = ""
    @State private var definitionText: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Word")) {
                    TextField("Enter word", text: $wordText)
                }
                Section(header: Text("Definition")) {
                    TextField("Enter definition", text: $definitionText)
                }
            }
            .navigationTitle("Add Word")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    //let newWord = WordItem(id: 1, word: wordText, definition: definitionText)
                    //viewModel.addWord(newWord)
                    presentationMode.wrappedValue.dismiss()
                }.disabled(wordText.isEmpty || definitionText.isEmpty)
            )
        }
    }
}

struct WordDetailView: View {
    var word: WordItem
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WordsViewModel

    var body: some View {
        VStack {
            Text(word.word)
                .font(.title)
            Text(word.definition)
                .padding()
            Spacer()
            HStack {
                Button("Edit") {
                    // Обработка редактирования
                    // Можно открыть форму редактирования
                }
                .padding()
                Spacer()
                Button("Delete") {
                    viewModel.showNotify(
                        title: "Delete Word",
                        message: "Are you sure you want to delete this word?",
                        primaryAction: {
                            // Удаляем запись
                            if let index = viewModel.words.firstIndex(where: { $0.id == word.id }) {
                                viewModel.words.remove(at: index)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .padding()
            }
        }
        .padding()
    }
}

// Кастомный SearchBar
struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
