//import Foundation
//import NaturalLanguage
//import CoreML
//
//// MARK: - Column Analysis Structure
//struct ColumnAnalysis {
//    let values: [String]
//    let language: String
//    let avgLength: Double
//    let emptyRatio: Double
//    let specialCharRatio: Double
//    let position: Int
//    
//    init(values: [String], position: Int, totalColumns: Int) {
//        self.values = values
//        self.position = position
//        
//        // Language detection
//        let text = values.joined(separator: " ")
//        self.language = detectCsvLanguage(for: text)
//        
//        // Length analysis
//        let totalLength = values.reduce(0) { $0 + $1.count }
//        self.avgLength = Double(totalLength) / Double(max(1, values.count))
//        
//        // Empty values analysis
//        let emptyCount = values.filter { $0.isEmpty }.count
//        self.emptyRatio = Double(emptyCount) / Double(max(1, values.count))
//        
//        // Special characters analysis
//        let specialChars = CharacterSet.punctuationCharacters
//            .union(.symbols)
//            .union(.nonBaseCharacters)
//        
//        let specialCharCount = values.reduce(0) { count, str in
//            count + str.unicodeScalars.filter { specialChars.contains($0) }.count
//        }
//        self.specialCharRatio = Double(specialCharCount) / Double(max(1, values.joined().count))
//    }
//}
//
//// MARK: - Column Relationship Analysis
//struct ColumnRelationship {
//    let column1: ColumnAnalysis
//    let column2: ColumnAnalysis
//    
//    var languageDifference: Bool {
//        return column1.language != column2.language &&
//               column1.language != "und" &&
//               column2.language != "und"
//    }
//    
//    var positionDistance: Int {
//        return abs(column1.position - column2.position)
//    }
//    
//    var lengthRatio: Double {
//        return column1.avgLength / max(1, column2.avgLength)
//    }
//}
//
//// MARK: - Column Classification Strategy
//class ColumnClassifier {
//    private let columns: [ColumnAnalysis]
//    
//    init(sampleData: [[String]]) {
//        guard let columnCount = sampleData.first?.count else {
//            columns = []
//            return
//        }
//        
//        // Transform data from rows to columns and analyze each column
//        self.columns = (0..<columnCount).map { columnIndex in
//            let columnValues = sampleData.compactMap { row in
//                columnIndex < row.count ? row[columnIndex] : nil
//            }
//            return ColumnAnalysis(
//                values: columnValues,
//                position: columnIndex,
//                totalColumns: columnCount
//            )
//        }
//    }
//    
//    func classifyColumns() -> [String] {
//        guard !columns.isEmpty else { return [] }
//        
//        var result = [String?](repeating: nil, count: columns.count)
//        var usedLabels = Set<String>()
//        
//        // First pass: Identify front_text and back_text pair
//        if let (frontIndex, backIndex) = findFrontBackPair() {
//            result[frontIndex] = "front_text"
//            result[backIndex] = "back_text"
//            usedLabels.insert("front_text")
//            usedLabels.insert("back_text")
//        }
//        
//        // Second pass: Identify hint and description
//        for (index, column) in columns.enumerated() where result[index] == nil {
//            if !usedLabels.contains("hint") && isLikelyHint(column) {
//                result[index] = "hint"
//                usedLabels.insert("hint")
//            } else if !usedLabels.contains("description") && isLikelyDescription(column) {
//                result[index] = "description"
//                usedLabels.insert("description")
//            }
//        }
//        
//        // Fill in any unclassified columns
//        return result.map { $0 ?? "unknown" }
//    }
//    
//    private func findFrontBackPair() -> (Int, Int)? {
//        var bestScore = -Double.infinity
//        var bestPair: (Int, Int)?
//        
//        for i in 0..<columns.count {
//            for j in (i+1)..<columns.count {
//                let relationship = ColumnRelationship(
//                    column1: columns[i],
//                    column2: columns[j]
//                )
//                
//                let score = scoreFrontBackPair(relationship)
//                if score > bestScore {
//                    bestScore = score
//                    bestPair = (i, j)
//                }
//            }
//        }
//        
//        return bestPair
//    }
//    
//    private func scoreFrontBackPair(_ relationship: ColumnRelationship) -> Double {
//        var score = 0.0
//        
//        // Different languages are a strong indicator (weight: 5.0)
//        if relationship.languageDifference {
//            score += 5.0
//        }
//        
//        // Adjacent columns are preferred (weight: 2.0)
//        score += 2.0 * (1.0 / Double(max(1, relationship.positionDistance)))
//        
//        // Similar lengths are preferred (weight: 1.5)
//        let lengthSimilarity = min(
//            relationship.lengthRatio,
//            1/relationship.lengthRatio
//        )
//        score += 1.5 * lengthSimilarity
//        
//        // Low empty ratios are preferred (weight: 2.0)
//        let emptyPenalty = (relationship.column1.emptyRatio + relationship.column2.emptyRatio) / 2
//        score -= 2.0 * emptyPenalty
//        
//        // Low special character ratios are preferred (weight: 1.0)
//        let specialCharPenalty = (relationship.column1.specialCharRatio + relationship.column2.specialCharRatio) / 2
//        score -= specialCharPenalty
//        
//        return score
//    }
//    
//    private func isLikelyHint(_ column: ColumnAnalysis) -> Bool {
//        // Hints are typically:
//        // 1. Shorter than descriptions
//        // 2. Have moderate empty ratio
//        // 3. Same language as front_text
//        // 4. Moderate special character ratio
//        
//        let score = 0.0
//            - (column.avgLength > 50 ? 2.0 : 0.0)
//            - (column.emptyRatio > 0.5 ? 1.0 : 0.0)
//            - (column.specialCharRatio > 0.1 ? 1.0 : 0.0)
//        
//        return score > -2.0
//    }
//    
//    private func isLikelyDescription(_ column: ColumnAnalysis) -> Bool {
//        // Descriptions are typically:
//        // 1. Longer than hints
//        // 2. Higher empty ratio
//        // 3. Same language as front_text
//        // 4. Can have more special characters
//        
//        let score = 0.0
//            + (column.avgLength > 100 ? 2.0 : 0.0)
//            + (column.emptyRatio > 0.3 ? 1.0 : 0.0)
//            + (column.specialCharRatio > 0.05 ? 0.5 : 0.0)
//        
//        return score > 2.0
//    }
//}
