import SwiftUI

class GreetingViewModel: ObservableObject {
    @Published var message: String = "Loading..."
    @Published var dictionaryItems: [QueryItem] = []
    
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol
    
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
        fetchDictionary()
    }
    
    func fetchDownload() {
        let requestBody = RequestDownloadBody(dictionary_key: "engheb.csv")
        let r = RequestDownload(apiManager: apiManager, logger: logger)
        
        r.invoke(requestBody: requestBody) { (result: Result<ResponseQuery, APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Обработка успешного ответа
                    print(response.data.items)
                case .failure(let error):
                    // Обработка ошибок
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func fetchDictionary() {
        let requestBody = RequestQueryBody()
        let r = RequestQuery(apiManager: apiManager, logger: logger)
        
        r.invoke(requestBody: requestBody) { (result: Result<ResponseQuery, APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Обработка успешного ответа
                    print(response.data.items)
                    self.dictionaryItems = response.data.items
                    self.message = "Data loaded"
                case .failure(let error):
                    // Обработка ошибок
                    print("Error: \(error)")
                    self.message = "Error fetching data"
                }
            }
        }
    }
}
