import Foundation
import SwiftCSV

struct CSVImporter {
    static func parseCSV(at url: URL) throws -> [WordItem] {
        var wordItems = [WordItem]()
        
        // Парсим CSV файл
        let csv = try CSV(url: url)
        
        for row in csv.namedRows {
            let frontText = row["front_text"] ?? ""
            let backText = row["back_text"] ?? ""
            let hint = row["hint"]
            let description = row["description"]
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
}

