import SwiftUI
import Combine
import SwiftCSV
import UIKit

// ViewModel для работы со словарями и CSV импортом
class DictionariesViewModel: BaseViewModel {
    @Published var dictionaries: [DictionaryItem] = []
    @Published var showAddOptions: Bool = false
    @Published var showFileImporter: Bool = false
    @Published var importError: String?
    @Published var importSuccess: Bool = false
    @Published var showDownloadServer: Bool = false
    @Published var selectedDictionary: DictionaryItem? = nil
    @Published var documentPickerURL: URL? = nil // Свойство для отслеживания выбранного файла


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
    
    // Функция, вызываемая при выборе файла
    func handleDocumentSelection(url: URL) {
        appState.logger.log("ViewModel: File URL received: \(url)", level: .info, details: nil) // Логируем получение URL
        documentPickerURL = url

        // Пытаемся вызвать importCSV с новым URL
        importCSV(from: url)
    }

    // Функция для обновления статуса словаря
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

    // Удаление словаря
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
        appState.logger.log("Selected file URL: \(url)", level: .info, details: nil) // Логируем URL файла

        Task {
            do {
                appState.logger.log("Import CSV called", level: .info, details: nil)

                // Попробуем получить доступ к защищенному ресурсу
                guard url.startAccessingSecurityScopedResource() else {
                    appState.logger.log("No access to file at URL", level: .error, details: nil)
                    throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadNoPermissionError, userInfo: [NSLocalizedDescriptionKey: "Нет доступа к файлу по указанному URL"])
                }
                defer { url.stopAccessingSecurityScopedResource() } // Освобождаем доступ после использования

                // Проверка доступности файла по пути
                guard FileManager.default.fileExists(atPath: url.path) else {
                    appState.logger.log("File not found at path: \(url.path)", level: .error, details: nil)
                    throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError, userInfo: [NSLocalizedDescriptionKey: "Файл не найден по указанному URL: \(url.path)"])
                }
                appState.logger.log("File exists at path: \(url.path)", level: .info, details: nil)

                // Получаем доступ к директории документов приложения
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationURL = documentDirectory.appendingPathComponent(url.lastPathComponent)

                // Удаляем файл, если он уже существует в директории документов
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }

                // Копируем файл в локальное хранилище
                try FileManager.default.copyItem(at: url, to: destinationURL)
                appState.logger.log("File copied to destination path: \(destinationURL)", level: .info, details: nil)

                // Чтение файла из нового местоположения
                let fileData = try Data(contentsOf: destinationURL)
                appState.logger.log("File data read successfully from destination path, size: \(fileData.count) bytes", level: .info, details: nil)

                // Преобразование данных файла в строку
                guard let fileString = String(data: fileData, encoding: .utf8) else {
                    appState.logger.log("Failed to convert file data to string", level: .error, details: nil)
                    throw NSError(domain: "CSVImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать данные файла в строку"])
                }
                appState.logger.log("File converted to string successfully", level: .info, details: nil)

                // Создание CSV объекта из строки
                let csv = try CSV(string: fileString)
                appState.logger.log("CSV object created successfully, rows count: \(csv.namedRows.count)", level: .info, details: nil)

                // Создание записи для базы данных
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
                appState.logger.log("Database table created: \(tableName)", level: .info, details: nil)

                var items: [DataItem] = []

                // Итерация по строкам CSV-файла
                for row in csv.namedRows {
                    guard let frontText = row.first?.value,
                          let backText = row.dropFirst().first?.value else {
                        appState.logger.log("Invalid CSV row format: \(row)", level: .error, details: nil)
                        continue
                    }

                    let description = row.dropFirst(2).first?.value
                    let hint = row.dropFirst(3).first?.value

                    let randomHashId = Int64.random(in: 0..<100_000_000_000_000_000)

                    let dataItem = DataItem(
                        hashId: randomHashId,
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

                appState.logger.log("Parsed \(items.count) items from CSV", level: .info, details: nil)

                // Вставка всех элементов в базу данных в одной транзакции
                try await appState.databaseManager.insertDataItems(items, intoTable: tableName)
                appState.logger.log("Inserted \(items.count) items into database", level: .info, details: nil)

                // Добавление записи о словаре в базу данных
                try await appState.databaseManager.insertDictionaryItem(dictionaryItem)
                appState.logger.log("Dictionary item inserted into database", level: .info, details: nil)

            } catch {
                appState.logger.log("Failed to parse and import CSV: \(error)", level: .error, details: nil)
            }
        }
    }



    // Загрузка словарей
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

// Представление для выбора файла с использованием UIDocumentPickerViewController
struct FileImporter: UIViewControllerRepresentable {
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
            print("Selected file URL: \(url)") // Логируем выбранный URL
            parent.didPickDocument(url)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
    }
}
