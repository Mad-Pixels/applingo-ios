//import Foundation
//import CoreXLSX
//
//final class ExcelParser: DictionaryParserProtocol {
//    func canHandle(fileExtension: String) -> Bool {
//        let ext = fileExtension.components(separatedBy: ".").last?.lowercased() ?? ""
//        return ["xlsx"].contains(ext) // Note: CoreXLSX поддерживает только .xlsx
//    }
//    
//    func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [DatabaseModelWord] {
//        Logger.debug("[ExcelParser] Starting to parse file: \(url.lastPathComponent)")
//        
//        guard let file = XLSXFile(filepath: url.path) else {
//            Logger.error("[ExcelParser] Failed to open Excel file")
//            throw DictionaryParserError.parsingFailed("Failed to open Excel file")
//        }
//        
//        // Получаем первый рабочий лист
//        guard let worksheet = try file.parseWorksheets().first else {
//            Logger.error("[ExcelParser] No worksheets found")
//            throw DictionaryParserError.parsingFailed("No worksheets found")
//        }
//        
//        let rows = try worksheet.cells
//            .grouped(by: { $0.reference.row })
//            .sorted { $0.key < $1.key }
//        
//        var words: [DatabaseModelWord] = []
//        var isFirstRow = true
//        
//        for row in rows {
//            // Пропускаем заголовок
//            if isFirstRow {
//                isFirstRow = false
//                continue
//            }
//            
//            let cells = row.value.sorted { $0.reference.column < $1.reference.column }
//            
//            // Нам нужно минимум 2 колонки с непустыми значениями
//            guard cells.count >= 2,
//                  let frontText = cells[0].value,
//                  let backText = cells[1].value,
//                  !frontText.isEmpty && !backText.isEmpty else {
//                continue
//            }
//            
//            let hint = cells.count > 2 ? cells[2].value ?? "" : ""
//            let description = cells.count > 3 ? cells[3].value ?? "" : ""
//            
//            let word = DatabaseModelWord(
//                dictionary: UUID().uuidString,
//                frontText: frontText,
//                backText: backText,
//                description: description,
//                hint: hint
//            )
//            words.append(word)
//        }
//        
//        guard !words.isEmpty else {
//            Logger.error("[ExcelParser] No valid words found in Excel file")
//            throw DictionaryParserError.parsingFailed("No valid word pairs found")
//        }
//        
//        Logger.debug("[ExcelParser] Successfully parsed \(words.count) words")
//        return words
//    }
//}
