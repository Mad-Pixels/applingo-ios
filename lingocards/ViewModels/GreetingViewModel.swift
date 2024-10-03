import SwiftUI

class GreetingViewModel: BaseViewModel {
    // Сообщение для отображения статуса
    @Published var message: String = "Loading..."
    // Массив элементов словаря
    @Published var dictionaryItems: [QueryItem] = []
    
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol
    
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
        super.init()
        fetchDictionary() // Загружаем словарь при инициализации
    }
    
    // Метод для загрузки файла
    func fetchDownload() {
        showPreloader() // Показываем индикатор загрузки
        let requestBody = RequestDownloadBody(dictionary_key: "engheb.csv")
        let r = RequestDownload(apiManager: apiManager, logger: logger)
        
        r.invoke(requestBody: requestBody) { [weak self] (result: Result<ResponseDownload, APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hidePreloader() // Скрываем индикатор загрузки
                switch result {
                case .success(let response):
                    print(response.data)
                    // Показываем уведомление об успешной загрузке
                    self.showNotify(title: "Success", message: "Download URL received", primaryAction: {})
                case .failure(let error):
                    print("Error: \(error)")
                    // Показываем алерт с ошибкой
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // Метод для загрузки словаря
    func fetchDictionary() {
        showPreloader() // Показываем индикатор загрузки
        let requestBody = RequestQueryBody()
        let r = RequestQuery(apiManager: apiManager, logger: logger)
        
        r.invoke(requestBody: requestBody) { [weak self] (result: Result<ResponseQuery, APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hidePreloader() // Скрываем индикатор загрузки
                switch result {
                case .success(let response):
                    self.dictionaryItems = response.data.items
                    self.message = "Data loaded"
                    // Показываем уведомление об успешной загрузке словаря
                    self.showNotify(title: "Success", message: "Dictionary loaded", primaryAction: {})
                case .failure(let error):
                    print("Error: \(error)")
                    self.message = "Error fetching data"
                    // Показываем алерт с ошибкой
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
