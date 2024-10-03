// GreetingViewModel.swift
import SwiftUI
import Combine

class GreetingViewModel: BaseViewModel {
    @Published var message: String = "Loading..."
    @Published var dictionaryItems: [QueryItem] = []

    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol

    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
        super.init()
        fetchDictionary()
    }

    func fetchDownload() {
        showPreloader()
        let requestBody = RequestDownloadBody(dictionary_key: "engheb.csv")
        let r = RequestDownload(apiManager: apiManager, logger: logger)

        r.invoke(requestBody: requestBody) { [weak self] (result: Result<ResponseDownload, APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hidePreloader()
                switch result {
                case .success(let response):
                    print(response.data)
                    self.showNotify(title: "Success", message: "Download URL received", primaryAction: {})
                case .failure(let error):
                    print("Error: \(error)")
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    func fetchDictionary() {
        showPreloader()
        let requestBody = RequestQueryBody()
        let r = RequestQuery(apiManager: apiManager, logger: logger)

        r.invoke(requestBody: requestBody) { [weak self] (result: Result<ResponseQuery, APIError>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hidePreloader()
                switch result {
                case .success(let response):
                    self.dictionaryItems = response.data.items
                    self.message = "Data loaded"
                    self.showNotify(title: "Success", message: "Dictionary loaded", primaryAction: {})
                case .failure(let error):
                    print("Error: \(error)")
                    self.message = "Error fetching data"
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
