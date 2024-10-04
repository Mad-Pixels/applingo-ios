// ViewModels/DictionariesViewModel.swift
import SwiftUI
import Combine

class DictionariesViewModel: BaseViewModel {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var showAddOptions: Bool = false
    @Published var showImportCSV: Bool = false
    @Published var showDownloadServer: Bool = false
    @Published var selectedDictionary: DictionaryItem? = nil // Для отображения деталей
    
    // Для данных "Download from server"
    @Published var serverDictionaries: [DictionaryItem] = []

    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        loadDictionaries()
    }
    
    func loadDictionaries() {
        // Загрузка словарей из источника данных
        // Сейчас используем тестовые данные
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
        isLoading = true
        // Симуляция сетевого запроса
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            // Тестовые данные сервера
            let serverData = [
                DictionaryItem(name: "Server Dictionary 1", description: "Server Description 1"),
                DictionaryItem(name: "Server Dictionary 2", description: "Server Description 2")
            ]
            DispatchQueue.main.async {
                self.isLoading = false
                self.serverDictionaries = serverData
                self.showDownloadServer = true
            }
        }
    }
    
    func importCSV() {
        // Обработка импорта CSV
        // Сейчас просто показываем алерт
        showAlert(title: "Import CSV", message: "CSV import functionality is not implemented yet.")
    }
}
