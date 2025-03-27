import Foundation

/// Представляет формат таблицы для парсинга
public struct ParserModelFormat {
    /// Разделитель полей для CSV
    let separator: String
    
    /// Символ кавычек для CSV
    let quoteCharacter: Character
    
    /// Наличие заголовка в файле
    let hasHeader: Bool
    
    /// Имена столбцов (если заголовок есть)
    let columnNames: [String]?
    
    /// Стандартный формат CSV с запятой в качестве разделителя
    public static let csv = ParserModelFormat(
        separator: ",",
        quoteCharacter: "\"",
        hasHeader: true,
        columnNames: nil
    )
    
    /// CSV формат с табуляцией в качестве разделителя
    public static let tsv = ParserModelFormat(
        separator: "\t",
        quoteCharacter: "\"",
        hasHeader: true,
        columnNames: nil
    )
    
    /// Формат JSON
    public static let json = ParserModelFormat(
        separator: "",
        quoteCharacter: "\"",
        hasHeader: false,
        columnNames: nil
    )
    
    /// Формат Excel
    public static let excel = ParserModelFormat(
        separator: "",
        quoteCharacter: "\"",
        hasHeader: true,
        columnNames: nil
    )
}
