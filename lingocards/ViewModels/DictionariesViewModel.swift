// ViewModels/DictionariesViewModel.swift
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
        // Сначала закрываем текущее окно добавления
        showAddOptions = false

        // Немного задерживаем открытие следующего окна, чтобы корректно завершить анимацию закрытия
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoading = true

            self.fetchTask?.cancel() // Отмена текущей загрузки, если есть

            // Имитация загрузки данных с сервера
            let future = Future<[DictionaryItem], Never> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    // Имитация серверных данных
                    let serverData = [
                        DictionaryItem(name: "Server Dictionary 1", description: "Server Description 1"),
                        DictionaryItem(name: "Server Dictionary 2", description: "Server Description 2")
                    ]
                    promise(.success(serverData))
                }
            }
            .receive(on: DispatchQueue.main) // Обработка данных на главном потоке

            // Сохранение задачи в fetchTask
            self.fetchTask = future
                .sink { [weak self] serverData in
                    self?.isLoading = false
                    self?.serverDictionaries = serverData
                    self?.showDownloadServer = true // Показ окна с результатами
                }

            // Добавляем fetchTask в cancellables для управления жизненным циклом
            self.fetchTask?.store(in: &self.cancellables)
        }
    }
    
    func importCSV() {
        showAddOptions = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showImportCSV = true
        }
    }

    func downloadSelectedDictionary(_ dictionary: DictionaryItem) {
        // Добавляем выбранный словарь
        dictionaries.append(dictionary)

        // Закрываем все открытые окна
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
