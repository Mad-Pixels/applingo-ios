import Foundation

struct TableFormat {
    let separator: String
    let hasHeader: Bool
    let quoteCharacter: Character
    let escapeCharacter: Character
    
    static let csv = TableFormat(
        separator: ",",
        hasHeader: true,
        quoteCharacter: "\"",
        escapeCharacter: "\\"
    )
    
    static let tsv = TableFormat(
        separator: "\t",
        hasHeader: true,
        quoteCharacter: "\"",
        escapeCharacter: "\\"
    )
}
