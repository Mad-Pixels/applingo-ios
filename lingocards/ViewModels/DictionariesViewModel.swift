// ViewModels/DictionariesViewModel.swift
import SwiftUI
import Combine
import SwiftCSV
import UIKit

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
    
    func updateDictionaryStatus(id: Int64, isActive: Bool) {
        Task {
            do {
                try await appState.databaseManager.updateDictionaryStatus(id: id, isActive: isActive)
                await MainActor.run {
                    if let index = dictionaries.firstIndex(where: { $0.id == id }) {
                        dictionaries[index].isActive = isActive
                    }
                }
            } catch {
                appState.logger.log("Failed to update dictionary status: \(error)", level: .error, details: nil)
            }
        }
    }
    
    func deleteDictionary(at offsets: IndexSet) {
            guard let index = offsets.first else { return }
            let dictionary = dictionaries[index]
            showNotify(
                title: "Delete Dictionary",
                message: "Are you sure you want to delete '\(dictionary.name)'?",
                primaryAction: {
                    Task {
                        do {
                            try await self.appState.databaseManager.deleteDictionaryItem(DatabaseDictionaryItem(
                                id: dictionary.id,
                                hashId: dictionary.id,  // Assuming hashId equals id for simplicity
                                displayName: dictionary.name,
                                tableName: "",
                                description: dictionary.description,
                                category: "",
                                author: "",
                                createdAt: 0,
                                isPrivate: false,
                                isActive: dictionary.isActive
                            ))
                            await MainActor.run {
                                self.dictionaries.remove(atOffsets: offsets)
                            }
                        } catch {
                            self.appState.logger.log("Failed to delete dictionary: \(error)", level: .error, details: nil)
                        }
                    }
                }
            )
        }
    
    /// Функция импорта CSV-файла
    func importCSV(from url: URL) {
        Task {
            do {
                // Проверка доступности файла и прав доступа
                guard url.startAccessingSecurityScopedResource() else {
                    throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadNoPermissionError, userInfo: [NSLocalizedDescriptionKey: "Нет доступа к файлу по указанному URL"])
                }
                defer { url.stopAccessingSecurityScopedResource() }
                
                // Создание объекта CSV из файла URL
                let csv = try CSV(url: url)
                
                let uniqueID = UUID().uuidString
                let tableName = "dict_\(uniqueID.replacingOccurrences(of: "-", with: "_"))"

                let dictionaryItem = DatabaseDictionaryItem(
                    id: Int64(Date().timeIntervalSince1970),
                    hashId: Int64(Date().timeIntervalSince1970),
                    displayName: "Imported Dictionary",
                    tableName: tableName,
                    description: "Imported CSV Dictionary",
                    category: "Imported",
                    author: "Unknown",
                    createdAt: Int64(Date().timeIntervalSince1970),
                    isPrivate: false,
                    isActive: true
                )
                
                // Создание таблицы в базе данных
                try await appState.databaseManager.createDataTable(forDictionary: dictionaryItem)

                var items: [DataItem] = []

                // Итерация по строкам CSV-файла
                for row in csv.namedRows {
                    // Проверяем, что строка содержит хотя бы 2 столбца
                    guard let frontText = row.first?.value,
                          let backText = row.dropFirst().first?.value else {
                        appState.logger.log("Invalid CSV row format: \(row)", level: .info, details: nil)
                        continue
                    }

                    let description = row.dropFirst(2).first?.value
                    let hint = row.dropFirst(3).first?.value
                    
                    let randomHashId = Int64.random(in: 0..<100_000_000_000_000_000)

                    // Создаем новый элемент `DataItem` с учетом обязательных и опциональных параметров
                    let dataItem = DataItem(
                        hashId: randomHashId, // Генерация уникального идентификатора
                        frontText: frontText,
                        backText: backText,
                        description: description,
                        hint: hint,
                        createdAt: Int64(Date().timeIntervalSince1970),
                        salt: 0,
                        success: 0,
                        fail: 0,
                        weight: 0,
                        tableName: tableName
                    )

                    items.append(dataItem)
                }

                // Вставка всех элементов в базу данных в одной транзакции
                try await appState.databaseManager.insertDataItems(items, intoTable: tableName)
                
                // Добавление записи о словаре в базу данных
                try await appState.databaseManager.insertDictionaryItem(dictionaryItem)
                
                // Логирование успешного создания таблицы и импорта данных
                appState.logger.log("Database table \(tableName) was created and filled with CSV data", level: .info, details: nil)
                
            } catch {
                appState.logger.log("Failed to parse and import CSV: \(error)", level: .error, details: nil)
            }
        }
    }
    
    func loadDictionaries() {
        Task {
            do {
                let items = try await appState.databaseManager.fetchDictionaries()
                await MainActor.run {
                    dictionaries = items.map { dbItem in
                        DictionaryItem(
                            id: dbItem.id,
                            name: dbItem.displayName,
                            description: dbItem.description,
                            isActive: dbItem.isActive
                        )
                    }
                }
            } catch {
                appState.logger.log("Failed to load dictionaries: \(error)", level: .error, details: nil)
            }
        }
    }
    
//    func deleteDictionary(at offsets: IndexSet) {
//        guard let index = offsets.first else { return }
//        let dictionary = dictionaries[index]
//        showNotify(
//            title: "Delete Dictionary",
//            message: "Are you sure you want to delete '\(dictionary.name)'?",
//            primaryAction: {
//                self.dictionaries.remove(atOffsets: offsets)
//            }
//        )
//    }
    
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
                        DictionaryItem(id: item.id, name: item.name, description: "\(item.author) - \(item.category_sub)", isActive: true)
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

// View для выбора файла с использованием UIDocumentPickerViewController
struct FileImporter: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    var didPickDocument: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FileImporter

        init(_ parent: FileImporter) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.didPickDocument(url)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
    }
}
