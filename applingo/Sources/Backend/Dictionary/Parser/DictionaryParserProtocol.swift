import Foundation

protocol DictionaryParserProtocol {
    func parse(
        url: URL,
        encoding: String.Encoding
    ) throws -> [DatabaseModelWord]
    
    func canHandle(fileExtension: String) -> Bool
}

