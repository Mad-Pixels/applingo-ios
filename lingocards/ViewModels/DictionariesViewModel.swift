// ViewModels/DictionariesViewModel.swift
import SwiftUI
import Combine

class DictionariesViewModel: BaseViewModel {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var showAddOptions: Bool = false
    @Published var showFileImporter: Bool = false
    @Published var importError: String?
    @Published var importSuccess: Bool = false
    @Published var showDownloadServer: Bool = false
    @Published var selectedDictionary: DictionaryItem? = nil
    
    // Для данных "Download from server"
    @Published var serverDictionaries: [DictionaryItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var fetchTask: AnyCancellable?
    private var appState: AppState

    // Конструктор с передачей appState
    init(appState: AppState) {
        self.appState = appState
        super.init()
        loadDictionaries()
    }
    
    func loadDictionaries() {
        dictionaries = [
            DictionaryItem(name: "Dictionary 1", description: "Description 1"),
            DictionaryItem(name: "Dictionary 2", description: "Description 2")
        ]
    }
    
    func deleteDictionary(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let dictionary = dictionaries[index]
        showNotify(
            title: "Delete Dictionary",
            message: "Are you sure you want to delete '\(dictionary.name)'?",
            primaryAction: {
                self.dictionaries.remove(atOffsets: offsets)
            }
        )
    }
    
    func showDictionaryDetails(_ dictionary: DictionaryItem) {
        selectedDictionary = dictionary
    }
    
    func fetchDictionariesFromServer() {
        showAddOptions = false
        isLoading = true

        Task {
            do {
                let requestBody = RequestQueryBody(is_public: true)
                let response: ResponseQuery = try await RequestQuery(apiManager: appState.apiManager, logger: appState.logger).invoke(requestBody: requestBody)
                
                DispatchQueue.main.async {
                    self.serverDictionaries = response.data.items.map { item in
                        DictionaryItem(name: item.name, description: "\(item.author) - \(item.category_sub)")
                    }
                    self.showDownloadServer = true
                }
            } catch {
                self.showAlert(title: "Error", message: "Failed to fetch dictionaries from server: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func importCSV() {
        showFileImporter = true
    }

    func downloadSelectedDictionary(_ dictionary: DictionaryItem) {
        dictionaries.append(dictionary)

        // Закрытие всех окон
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showDownloadServer = false
            self.selectedDictionary = nil
            self.showAddOptions = false
        }
    }
    
    func cancelLoading() {
        isLoading = false
        fetchTask?.cancel()
        fetchTask = nil
    }
}
