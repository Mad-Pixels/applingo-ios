import SwiftUI

class GreetingViewModel: ObservableObject {
    @Published var message: String = "Loading..."
    @Published var dictionaryItems: [QueryItem] = []
    private let apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
        fetchDictionary()
    }
    
    func fetchDictionary() {
        let requestBody = QueryRequestBody()
        let r = QueryRequest(apiManager: apiManager)
        
        r.query(requestBody: requestBody) { (result: Result<QueryResponse, APIError>) in
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
