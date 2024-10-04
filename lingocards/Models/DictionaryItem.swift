import Foundation

struct DictionaryItem: Identifiable {
    let id: UUID = UUID()
    var name: String
    var description: String
}

// Models/WordItem.swift
import Foundation

struct WordItem: Identifiable {
    let id: UUID = UUID()
    var word: String
    var definition: String
}
