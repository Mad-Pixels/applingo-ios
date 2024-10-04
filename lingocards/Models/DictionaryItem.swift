import Foundation

struct DictionaryItem: Identifiable, Equatable {
    let id: UUID = UUID()
    var name: String
    var description: String

    static func ==(lhs: DictionaryItem, rhs: DictionaryItem) -> Bool {
        lhs.id == rhs.id
    }
}

// Models/WordItem.swift
import Foundation

struct WordItem: Identifiable {
    let id: UUID = UUID()
    var word: String
    var definition: String
}
