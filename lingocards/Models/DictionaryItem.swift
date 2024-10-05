import Foundation

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

struct WordItem: Identifiable {
    let id: Int64
    var word: String
    var definition: String
}
