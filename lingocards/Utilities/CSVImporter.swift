import Foundation

struct CSVImporter {
    static func parseCSV(at url: URL) throws -> [WordItem] {
        var wordItems = [WordItem]()
        
        // Читаем содержимое файла в строку
        let content = try String(contentsOf: url, encoding: .utf8)
        
        // Разбиваем содержимое на строки
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            // Удаляем пробелы и проверяем, что строка не пустая
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedLine.isEmpty else {
                continue  // Пропускаем пустые строки
            }
            
            // Разбиваем строку на колонки по разделителю ","
            let columns = parseCSVLine(line: trimmedLine)
            
            // Проверяем количество элементов в строке
            guard columns.count >= 2 else {
                continue  // Пропускаем строки с недостаточным количеством данных
            }
            
            // Индексы столбцов:
            // 0 - front_text
            // 1 - back_text
            // 2 - hint (опционально)
            // 3 - description (опционально)
            
            let frontText = columns[0]
            let backText = columns[1]
            let hint = columns.count > 2 ? columns[2] : nil
            let description = columns.count > 3 ? columns[3] : nil
            let createdAt = Int(Date().timeIntervalSince1970)
            
            let wordItem = WordItem(
                id: 0,  // ID сгенерируется в БД
                hashId: Int.random(in: Int.min...Int.max),  // Генерация случайного хеша
                tableName: "",  // Это будет обновлено позже
                frontText: frontText,
                backText: backText,
                description: description,
                hint: hint,
                createdAt: createdAt,
                salt: 0
            )
            wordItems.append(wordItem)
        }
        
        return wordItems
    }
    
    // Простой парсер строки CSV, учитывающий кавычки и запятые внутри кавычек
    static func parseCSVLine(line: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var insideQuotes = false
        var iterator = line.makeIterator()
        
        while let char = iterator.next() {
            if char == "\"" {
                if insideQuotes, let nextChar = iterator.next() {
                    if nextChar == "\"" {
                        // Escaped quote
                        currentField.append("\"")
                    } else {
                        // Toggle insideQuotes and reprocess the character
                        insideQuotes.toggle()
                        if nextChar != "," {
                            currentField.append(nextChar)
                        } else {
                            result.append(currentField)
                            currentField = ""
                        }
                    }
                } else {
                    insideQuotes.toggle()
                }
            } else if char == "," && !insideQuotes {
                result.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        // Добавляем последний столбец
        result.append(currentField)
        return result
    }
}
