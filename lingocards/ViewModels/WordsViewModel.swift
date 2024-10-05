import SwiftUI
import Combine

class WordsViewModel: BaseViewModel {
    @Published var words: [WordItem] = []
    @Published var showAddWordForm: Bool = false
    @Published var searchText: String = ""
    @Published var selectedWord: WordItem? = nil // Для отображения деталей
    //@Published var isLoading = false // Отображение индикатора загрузки
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 0
    private var itemsPerPage = 20
    private var canLoadMorePages = true

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
    
    func loadWords(reset: Bool = false) {
        guard !isLoading else { return }
        
        if reset {
            words = []
            currentPage = 0
            canLoadMorePages = true
        }
        
        isLoading = true
        Task {
            do {
                let newWords = try await AppState.shared.databaseManager.fetchWords(page: currentPage, itemsPerPage: itemsPerPage)
                DispatchQueue.main.async {
                    self.words.append(contentsOf: newWords)
                    self.currentPage += 1
                    self.isLoading = false
                    self.canLoadMorePages = newWords.count == self.itemsPerPage
                }
            } catch {
                self.isLoading = false
                AppState.shared.logger.log("Failed to load words: \(error)", level: .error, details: nil)
            }
        }
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
    
    func loadNextPageIfNeeded(currentItem: WordItem?) {
        guard let currentItem = currentItem else {
            loadWords()
            return
        }
        
        let thresholdIndex = words.index(words.endIndex, offsetBy: -5)
        if words.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex, canLoadMorePages {
            loadWords()
        }
    }
}
