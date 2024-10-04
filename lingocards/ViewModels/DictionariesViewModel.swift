// ViewModels/DictionariesViewModel.swift
import SwiftUI
import Combine

import SwiftUI
import Combine

class DictionariesViewModel: BaseViewModel {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var showAddOptions: Bool = false
    @Published var showImportCSV: Bool = false
    @Published var showDownloadServer: Bool = false
    @Published var selectedDictionary: DictionaryItem? = nil
    
    // Для данных "Download from server"
    @Published var serverDictionaries: [DictionaryItem] = []

    private var cancellables = Set<AnyCancellable>()
    private var fetchTask: AnyCancellable?
    
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
                self.resetFlags()
            }
        )
    }
    
    func showDictionaryDetails(_ dictionary: DictionaryItem) {
        selectedDictionary = dictionary
        resetFlags()
    }
    
    func fetchDictionariesFromServer() {
        isLoading = true
        resetFlags()
        
        fetchTask?.cancel()

        // Симуляция сетевого запроса
        let future = Future<[DictionaryItem], Never> { promise in
            // Симуляция сетевого запроса
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                // Тестовые данные сервера
                let serverData = [
                    DictionaryItem(name: "Server Dictionary 1", description: "Server Description 1"),
                    DictionaryItem(name: "Server Dictionary 2", description: "Server Description 2")
                ]
                promise(.success(serverData))
            }
        }
        .receive(on: DispatchQueue.main)
        
        // Сохраняем ссылку на текущую задачу загрузки
        fetchTask = future
            .sink { [weak self] serverData in
                self?.isLoading = false
                self?.serverDictionaries = serverData
                self?.showDownloadServer = true
            }
        
        // Храним fetchTask в наборе cancellables для корректного управления жизненным циклом
        fetchTask?.store(in: &cancellables)
    }
    
    func importCSV() {
        // Обработка импорта CSV
        // Сейчас просто показываем алерт
        resetFlags()
        showAlert(title: "Import CSV", message: "CSV import functionality is not implemented yet.")
    }
    
    private func resetFlags() {
        showAddOptions = false
        showImportCSV = false
        showDownloadServer = false
        selectedDictionary = nil
    }
    
    func cancelLoading() {
        isLoading = false
        fetchTask?.cancel()
        fetchTask = nil
        resetFlags()
    }
}
