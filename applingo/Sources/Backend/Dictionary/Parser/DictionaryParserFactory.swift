import Foundation

final class DictionaryParserFactory {
    static let shared = DictionaryParserFactory()
    
    private var parsers: [DictionaryParserProtocol] = [
        DelimitedTextParser(format: .csv),
        DelimitedTextParser(format: .tsv),
        //ExcelParser()  // Добавляем парсер Excel
    ]
    
    private init() {}
    
    func parser(for url: URL) throws -> DictionaryParserProtocol {
        let fileExtension = url.lastPathComponent
        Logger.debug("[DictionaryParserFactory] Looking for parser for file: \(fileExtension)")
        
        guard let parser = parsers.first(where: { $0.canHandle(fileExtension: fileExtension) }) else {
            Logger.error("[DictionaryParserFactory] No parser found for extension: \(fileExtension)")
            throw DictionaryParserError.unsupportedFormat
        }
        
        return parser
    }
}
