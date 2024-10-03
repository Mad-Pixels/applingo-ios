import SwiftUI
import Combine

class GreetingViewModel: BaseViewModel {
    @Published var message: String = "Loading..."
    @Published var dictionaryItems: [QueryItem] = []
    
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol

    /// Инициализатор с внедрением зависимостей.
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
        super.init()
        Task {
            await fetchDictionary()
        }
    }

    /// Метод для загрузки URL файла для скачивания.
    func fetchDownload() {
        Task {
            await MainActor.run { showPreloader() } // Показать индикатор загрузки в главном потоке
            defer { Task { await MainActor.run { hidePreloader() } } } // Скрыть индикатор загрузки в главном потоке

            do {
                let requestBody = RequestDownloadBody(dictionary_key: "engheb.csv")
                let response: ResponseDownload = try await RequestDownload(apiManager: apiManager, logger: logger).invoke(requestBody: requestBody)
                
                // Успешное получение URL для скачивания
                print(response.data)
                await MainActor.run { showNotify(title: "Success", message: "Download URL received", primaryAction: {}) }
            } catch {
                await handleError(error, title: "Error", fallbackMessage: "Failed to fetch download URL.")
            }
        }
    }

    /// Метод для получения словаря.
    func fetchDictionary() {
        Task {
            await MainActor.run { showPreloader() } // Показать индикатор загрузки в главном потоке
            defer { Task { await MainActor.run { hidePreloader() } } } // Скрыть индикатор загрузки в главном потоке

            do {
                let requestBody = RequestQueryBody()
                let response: ResponseQuery = try await RequestQuery(apiManager: apiManager, logger: logger).invoke(requestBody: requestBody)
                
                // Успешное получение данных словаря
                await MainActor.run {
                    dictionaryItems = response.data.items
                    message = "Data loaded"
                    showNotify(title: "Success", message: "Dictionary loaded", primaryAction: {})
                }
            } catch {
                await handleError(error, title: "Error", fallbackMessage: "Failed to fetch dictionary data.")
            }
        }
    }
    
    /// Универсальный метод для обработки ошибок и показа алерта.
    @MainActor
    private func handleError(_ error: Error, title: String, fallbackMessage: String) {
        if let apiError = error as? APIError {
            logger.log("API request failed: \(apiError)", level: .error, details: nil)
            showAlert(title: title, message: apiError.localizedDescription)
        } else {
            logger.log("Unexpected error: \(error)", level: .error, details: nil)
            showAlert(title: title, message: fallbackMessage)
        }
        message = fallbackMessage
    }
}
