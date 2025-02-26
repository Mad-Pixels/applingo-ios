import Foundation

/// A parser that handles JSON files containing word information.
public final class ParserJSON: AbstractParser {
    private let format: ParserModelFormat
    
    /// Initializes the JSON parser with the given `TableFormat`.
    /// - Parameter format: The table format.
    public init(format: ParserModelFormat = .json) {
        self.format = format
    }
    
    /// Checks if the file has an extension `.json`.
    /// - Parameter fileExtension: The file extension (e.g. "json", "JSON", etc.).
    /// - Returns: `true` if the file extension indicates a JSON file.
    public func canHandle(fileExtension: String) -> Bool {
        let ext = fileExtension.lowercased()
        return ext == "json" || ext.hasSuffix(".json")
    }
    
    /// Parses a JSON file from the given URL.
    /// - Parameters:
    ///   - url: The URL to the JSON file.
    ///   - encoding: The encoding to use (default is `.utf8`).
    /// - Returns: An array of `ParserModelWord`.
    /// - Throws: `ParserError` if the file is empty or has invalid format.
    public func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [ParserModelWord] {
        Logger.debug(
            "[Parser]: Starting to parse JSON",
            metadata: [
                "url": "\(url)",
                "encoding": "\(encoding)"
            ]
        )
        
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            Logger.debug(
                "[Parser]: Failed to read file content",
                metadata: [
                    "error": "\(error)"
                ]
            )
            throw ParserError.fileReadFailed("Could not read file at \(url)")
        }
        
        guard !data.isEmpty else {
            Logger.debug("[Parser]: File is empty")
            throw ParserError.emptyFile
        }
        
        return try parseJSON(data)
    }
    
    /// Parses JSON data containing word information.
    /// - Parameter data: The JSON data.
    /// - Returns: An array of `ParserModelWord`.
    /// - Throws: `ParserError` if JSON is invalid or has unexpected structure.
    private func parseJSON(_ data: Data) throws -> [ParserModelWord] {
        do {
            // Define the structure of JSON
            struct JSONWord: Decodable {
                let word: String
                let translation: String
                let hint: String?
                let description: String?
            }
            
            struct JSONContainer: Decodable {
                let words: [JSONWord]
            }
            
            let decoder = JSONDecoder()
            let container = try decoder.decode(JSONContainer.self, from: data)
            
            Logger.debug(
                "[Parser]: Successfully decoded JSON",
                metadata: [
                    "words_count": "\(container.words.count)"
                ]
            )
            
            guard !container.words.isEmpty else {
                Logger.debug("[Parser]: No words found in JSON")
                throw ParserError.parsingFailed("No words found in JSON file")
            }
            
            var parsedWords = [ParserModelWord]()
            
            for (index, jsonWord) in container.words.enumerated() {
                // Skip words with empty front or back text
                if jsonWord.word.isEmpty || jsonWord.translation.isEmpty {
                    Logger.debug(
                        "[Parser]: Skipping word due to empty front/back text",
                        metadata: [
                            "word_index": "\(index)"
                        ]
                    )
                    continue
                }
                
                let word = ParserModelWord(
                    dictionary: UUID().uuidString,
                    frontText: jsonWord.word,
                    backText: jsonWord.translation,
                    description: jsonWord.description ?? "",
                    hint: jsonWord.hint ?? ""
                )
                parsedWords.append(word)
            }
            
            guard !parsedWords.isEmpty else {
                Logger.debug("[Parser]: No valid words found after filtering")
                throw ParserError.parsingFailed("No valid word entries found in JSON file")
            }
            
            Logger.debug(
                "[Parser]: Successfully parsed JSON words",
                metadata: [
                    "words_count": "\(parsedWords.count)"
                ]
            )
            
            return parsedWords
            
        } catch let decodingError as DecodingError {
            Logger.debug(
                "[Parser]: JSON decoding error",
                metadata: [
                    "error": "\(decodingError)"
                ]
            )
            throw ParserError.invalidFormat("Invalid JSON format: \(decodingError.localizedDescription)")
        } catch {
            Logger.debug(
                "[Parser]: Other parsing error",
                metadata: [
                    "error": "\(error)"
                ]
            )
            throw ParserError.parsingFailed("Failed to parse JSON: \(error.localizedDescription)")
        }
    }
}
