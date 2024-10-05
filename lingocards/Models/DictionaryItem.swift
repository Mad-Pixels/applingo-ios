import Foundation
import GRDB

struct DictionaryItem: Identifiable, Equatable {
    let id: Int64
    var name: String
    var description: String
    var isActive: Bool

    static func ==(lhs: DictionaryItem, rhs: DictionaryItem) -> Bool {
        lhs.id == rhs.id
    }
}

// Models/WordItem.swift
import Foundation

struct WordItem: Identifiable, Codable, FetchableRecord, PersistableRecord {
    var id: Int64?
    var hashId: Int64
    var word: String
    var definition: String
    
    // Переопределяем инициализатор для соответствия протоколу FetchableRecord
    init(row: Row) {
        id = row["id"]
        hashId = row["hashId"]
        word = row["frontText"]
        definition = row["backText"]
    }
    
    // Метод для вставки или обновления данных
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["hashId"] = hashId
        container["frontText"] = word
        container["backText"] = definition
    }
    
    // Переопределяем название таблицы, если оно отличается от названия структуры
    static var databaseTableName: String {
        return "WordItem"
    }
}
