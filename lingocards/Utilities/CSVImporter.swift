import SwiftUI
import UniformTypeIdentifiers
import NaturalLanguage
import CoreML
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText])
        documentPicker.delegate = context.coordinator
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .fullScreen
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let pickedURL = urls.first else { return }

            // Начинаем доступ к защищённому ресурсу
            let success = pickedURL.startAccessingSecurityScopedResource()
            if success {
                defer { pickedURL.stopAccessingSecurityScopedResource() }

                do {
                    // Координируем доступ к файлу
                    let fileCoordinator = NSFileCoordinator()
                    var error: NSError?
                    var fileData: Data?

                    fileCoordinator.coordinate(readingItemAt: pickedURL, options: [], error: &error) { (newURL) in
                        do {
                            fileData = try Data(contentsOf: newURL)
                        } catch {
                            print("Ошибка при чтении данных файла: \(error.localizedDescription)")
                        }
                    }

                    if let coordError = error {
                        print("Ошибка координации доступа к файлу: \(coordError.localizedDescription)")
                    }

                    guard let data = fileData else {
                        print("Не удалось прочитать данные файла")
                        return
                    }

                    // Копируем файл в директорию приложения
                    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let destURL = documentDirectory.appendingPathComponent(pickedURL.lastPathComponent)
                    
                    do {
                        try data.write(to: destURL)
                        print("Файл сохранён в: \(destURL.path)")
                    } catch {
                        print("Ошибка при сохранении файла: \(error.localizedDescription)")
                    }
                    
                    // Продолжаем обработку файла
                    do {
                        let wordItems = try CSVImporter.parseCSV(at: destURL, tableName: "your_table_name")
                        // Дальнейшая обработка wordItems
                        print("Импортировано \(wordItems.count) слов")
                    } catch {
                        print("Ошибка при парсинге CSV: \(error.localizedDescription)")
                    }

                } catch {
                    print("Ошибка при доступе к файлу: \(error.localizedDescription)")
                }
            } else {
                print("Не удалось получить доступ к защищённому ресурсу")
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("Отмена выбора документа")
        }
    }
}

struct CSVImporter {
    static let model: ColumnClassifier = {
        let config = MLModelConfiguration()
        return try! ColumnClassifier(configuration: config)
    }()

    static func parseCSV(at url: URL, tableName: String) throws -> [WordItem] {
        var wordItems = [WordItem]()
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            let sampleLines = lines.prefix(15)
            var sampleColumnsMatrix = [[String]]()
            
            for line in sampleLines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedLine.isEmpty else { continue }
                
                let columns = parseCSVLine(line: trimmedLine)
                sampleColumnsMatrix.append(columns)
            }
            
            var columnLabels: [String]
            do {
                if let classifiedLabels = try classifyColumns(sampleColumnsMatrix: sampleColumnsMatrix) {
                    columnLabels = classifiedLabels
                } else {
                    print("[CSVImporter]: Classifier failed to classify columns, using default column labels")
                    columnLabels = ["front_text", "back_text", "hint", "description"]
                }
            } catch {
                print("[CSVImporter]: Classifier encountered an error: \(error.localizedDescription), using default column labels")
                columnLabels = ["front_text", "back_text", "hint", "description"]
            }
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedLine.isEmpty else { continue }
                
                let columns = parseCSVLine(line: trimmedLine)
                if columns.isEmpty { continue }
                
                if columns.count > columnLabels.count {
                    let additionalLabels = Array(repeating: "description", count: columns.count - columnLabels.count)
                    columnLabels.append(contentsOf: additionalLabels)
                }
                
                var description: String?
                var frontText: String?
                var backText: String?
                var hint: String?
                
                for (index, value) in columns.enumerated() {
                    let columnLabel = index < columnLabels.count ? columnLabels[index] : "description"
                    switch columnLabel {
                    case "front_text":
                        frontText = value
                    case "back_text":
                        backText = value
                    case "hint":
                        hint = value
                    case "description":
                        description = value
                    default:
                        break
                    }
                }
                
                guard let ft = frontText, let bt = backText else { continue }
                
                let wordItem = WordItem(
                    tableName: tableName,
                    frontText: ft,
                    backText: bt,
                    description: description,
                    hint: hint
                )
                wordItems.append(wordItem)
            }
            return wordItems
        } catch {
            print("Ошибка при чтении файла CSV: \(error.localizedDescription)")
            throw error
        }
    }

    static func classifyColumns(sampleColumnsMatrix: [[String]]) throws -> [String]? {
        guard let numberOfColumns = sampleColumnsMatrix.first?.count else { return nil }
        var columnLabels = [String]()
        
        for columnIndex in 0..<numberOfColumns {
            var predictionsCount = [String: Int]()
            
            for row in sampleColumnsMatrix {
                if columnIndex >= row.count { continue }
                
                let text = row[columnIndex]
                let language = detectLanguage(for: text)
                let length = Int64(text.count)
                let isEmpty = text.isEmpty ? "true" : "false"
                
                let input = ColumnClassifierInput(
                    Language: language,
                    Length: length,
                    Column_Index: Int64(columnIndex),
                    Is_Empty: isEmpty
                )
                
                let prediction = try model.prediction(input: input)
                let label = prediction.Label
                
                predictionsCount[label, default: 0] += 1
            }
            
            if let (mostFrequentLabel, _) = predictionsCount.max(by: { $0.value < $1.value }) {
                columnLabels.append(mostFrequentLabel)
            } else {
                return nil
            }
        }
        return columnLabels
    }

    static func detectLanguage(for text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        if let language = recognizer.dominantLanguage {
            let languageCode = language.rawValue

            let knownLanguages: Set<String> = [
                "de",
                "en",
                "es",
                "fr",
                "he",
                "ru",
                "zh",
                "und"
            ]
            if knownLanguages.contains(languageCode) {
                return languageCode
            } else {
                return "und"
            }
        }
        return "und"
    }

    static func parseCSVLine(line: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var insideQuotes = false
        var iterator = line.makeIterator()
        
        while let char = iterator.next() {
            if char == "\"" {
                if insideQuotes {
                    if let nextChar = iterator.next() {
                        if nextChar == "\"" {
                            currentField.append("\"")
                        } else {
                            insideQuotes = false
                            if nextChar != "," {
                                currentField.append(nextChar)
                            } else {
                                result.append(currentField)
                                currentField = ""
                            }
                        }
                    } else {
                        insideQuotes = false
                    }
                } else {
                    insideQuotes = true
                }
            } else if char == "," && !insideQuotes {
                result.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        result.append(currentField)
        return result
    }
}

// Определите здесь ваши модели данных, такие как WordItem, ColumnClassifierInput и другие необходимые
// Например:



// И не забудьте добавить модель ColumnClassifier в ваш проект и убедиться, что она корректно импортируется
