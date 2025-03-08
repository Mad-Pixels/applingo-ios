// ParserJSON.swift
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
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let rootDict = json as? [String: Any],
                  let wordsArray = rootDict["words"] as? [[String: Any]] else {
                Logger.debug("[Parser]: JSON structure is not as expected")
                throw ParserError.invalidFormat("JSON structure is not as expected")
            }
            
            var parsedWords = [ParserModelWord]()
            
            for (index, wordDict) in wordsArray.enumerated() {
                guard let word = wordDict["word"] as? String,
                      let translation = wordDict["translation"] as? String,
                      !word.isEmpty, !translation.isEmpty else {
                    Logger.debug(
                        "[Parser]: Skipping word due to missing or empty required fields",
                        metadata: [
                            "word_index": "\(index)"
                        ]
                    )
                    continue
                }
                
                let description = wordDict["description"] as? String ?? ""
                let hint = wordDict["hint"] as? String ?? ""
                
                let parsedWord = ParserModelWord(
                    dictionary: UUID().uuidString,
                    frontText: word,
                    backText: translation,
                    description: description,
                    hint: hint
                )
                parsedWords.append(parsedWord)
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
        } catch {
            Logger.debug(
                "[Parser]: JSON parsing error",
                metadata: [
                    "error": "\(error)"
                ]
            )
            throw ParserError.invalidFormat("Invalid JSON format: \(error.localizedDescription)")
        }
    }
}
