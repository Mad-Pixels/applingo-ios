import Foundation
import Combine

final class DictionaryRemoteGetterViewModel: ObservableObject {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var searchText: String = ""
    
    private var isLoadingPage = false
    private var hasMorePagesUp = true
    private var hasMorePagesDown = true
    
    enum LoadDirection {
        case up
        case down
    }
    
    // Сброс пагинации
    func resetPagination() {
        dictionaries.removeAll()
        isLoadingPage = false
        hasMorePagesUp = true
        hasMorePagesDown = true
        getRemoteDictionaries(query: DictionaryQueryRequest(isPublic: true), direction: .down)
    }
    
    // Заглушка для получения словарей с удаленного сервера
    func getRemoteDictionaries(query: DictionaryQueryRequest, direction: LoadDirection = .down) {
        guard !isLoadingPage else { return }
        isLoadingPage = true
        
        Logger.debug("[DictionaryRemoteViewModel]: Fetching remote dictionaries with query parameters: \(query)")
        
        // Симуляция сетевого запроса с вероятностью ошибки 10%
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                if Int.random(in: 1...10) <= 1 {
                    Logger.debug("[DictionaryRemoteViewModel]: Failed to fetch remote dictionaries")
                    
                    self.dictionaries = []
                    
                    let error = AppError(
                        errorType: .network,
                        errorMessage: "Failed to fetch data from remote server",
                        additionalInfo: nil
                    )
                    
                    // Устанавливаем ошибку в ErrorManager
                    ErrorManager.shared.setError(
                        appError: error,
                        tab: .dictionaries,
                        source: .dictionariesRemoteGet
                    )
                    
                    self.isLoadingPage = false
                    return
                }
                
                // Пример данных, которые будут получены
                let remoteData: [DictionaryItem] = [
                    DictionaryItem(displayName: "Italian Words", tableName: "italian_words", description: "Basic Italian vocabulary", category: "Language", subcategory: "it-en", author: "Author6"),
                    DictionaryItem(displayName: "Japanese Words", tableName: "japanese_words", description: "Basic Japanese vocabulary", category: "Language", subcategory: "ja-en", author: "Author7")
                ]
                
                // Обновляем данные в зависимости от направления загрузки
                switch direction {
                case .down:
                    self.dictionaries.append(contentsOf: remoteData)
                    //self.hasMorePagesDown = remoteData.count == self.itemsPerPage
                case .up:
                    self.dictionaries.insert(contentsOf: remoteData, at: 0)
                    //self.hasMorePagesUp = remoteData.count == self.itemsPerPage
                }
                
                // Очищаем ошибки при успешном выполнении запроса
                ErrorManager.shared.clearError(for: .dictionariesRemoteGet)
                Logger.debug("[DictionaryRemoteViewModel]: Remote dictionaries data successfully fetched")
                
                self.isLoadingPage = false
            }
        }
    }
    
    // Загрузка дополнительных данных при необходимости
    func loadMoreDictionariesIfNeeded(currentItem dictionary: DictionaryItem?) {
        guard let dictionary = dictionary else { return }
        
        if let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
            if index <= 5 && hasMorePagesUp && !isLoadingPage {
                getRemoteDictionaries(query: DictionaryQueryRequest(isPublic: true), direction: .up)
            } else if index >= dictionaries.count - 5 && hasMorePagesDown && !isLoadingPage {
                getRemoteDictionaries(query: DictionaryQueryRequest(isPublic: true), direction: .down)
            }
        }
    }
}
