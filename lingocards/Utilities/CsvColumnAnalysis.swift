import Foundation

struct CsvColumnAnalysis {
    let values: [String]
    let language: String
    let avgLength: Double
    let emptyRatio: Double
    let specialCharRatio: Double
    let position: Int
    
    init(values: [String], position: Int, totalColumns: Int) {
        self.values = values
        self.position = position
        
        // Language detection
        let text = values.joined(separator: " ")
        self.language = detectCsvLanguage(for: text)
        
        // Length analysis
        let totalLength = values.reduce(0) { $0 + $1.count }
        self.avgLength = Double(totalLength) / Double(max(1, values.count))
        
        // Empty values analysis
        let emptyCount = values.filter { $0.isEmpty }.count
        self.emptyRatio = Double(emptyCount) / Double(max(1, values.count))
        
        // Special characters analysis
        let specialChars = CharacterSet.punctuationCharacters
            .union(.symbols)
            .union(.nonBaseCharacters)
        
        let specialCharCount = values.reduce(0) { count, str in
            count + str.unicodeScalars.filter { specialChars.contains($0) }.count
        }
        self.specialCharRatio = Double(specialCharCount) / Double(max(1, values.joined().count))
    }
}
