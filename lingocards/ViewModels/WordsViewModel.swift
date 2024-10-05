import SwiftUI
import Combine

class WordsViewModel: BaseViewModel {
    @Published var words: [WordItem] = []
    @Published var showAddWordForm: Bool = false
    @Published var searchText: String = ""
    @Published var selectedWord: WordItem? = nil // Для отображения деталей

    private var cancellables = Set<AnyCancellable>()
    
    var filteredWords: [WordItem] {
        if searchText.isEmpty {
            return words
        } else {
            return words.filter { $0.word.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    override init() {
        super.init()
        loadWords()
    }
    
    func loadWords() {
        // Загрузка слов из источника данных
        // Сейчас используем тестовые данные
        words = [
            WordItem(id: 1, word: "Apple", definition: "A fruit"),
            WordItem(id: 2, word: "Banana", definition: "Another fruit")
        ]
    }
    
    func deleteWord(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let word = words[index]
        showNotify(
            title: "Delete Word",
            message: "Are you sure you want to delete '\(word.word)'?",
            primaryAction: {
                self.words.remove(atOffsets: offsets)
            }
        )
    }
    
    func addWord(_ word: WordItem) {
        words.append(word)
    }
    
    func showWordDetails(_ word: WordItem) {
        selectedWord = word
    }
}

