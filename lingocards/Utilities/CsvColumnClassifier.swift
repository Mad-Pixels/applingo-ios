import Foundation

final class CsvColumnClassifier {
    private let columns: [CsvColumnAnalysis]
    
    init(sampleData: [[String]]) {
        guard let columnCount = sampleData.first?.count else {
            columns = []
            return
        }
        
        self.columns = (0..<columnCount).map { columnIndex in
            let columnValues = sampleData.compactMap { row in
                columnIndex < row.count ? row[columnIndex] : nil
            }
            return CsvColumnAnalysis(
                values: columnValues,
                position: columnIndex,
                totalColumns: columnCount
            )
        }
    }
    
    private struct ColumnCharacteristics {
        let values: [String]
        let latinRatio: Double
        let nonLatinRatio: Double
        let avgWordLength: Double
        let emptyRatio: Double
        let specialCharRatio: Double
        let position: Int
        let multilineRatio: Double
        let uniqueValuesRatio: Double
        let wordCount: Double  // Среднее количество слов в значении
        
        var isMainlyLatin: Bool {
            return latinRatio > 0.7
        }
        
        var isMainlyNonLatin: Bool {
            return nonLatinRatio > 0.7
        }
    }
    
    func classifyColumns() -> [String] {
        guard columns.count >= 2 else { return [] }
        
        let columnAnalyses = columns.enumerated().map { index, column in
            analyzeColumn(column, at: index)
        }
        
        // 1. Сначала ищем наиболее вероятную пару front_text/back_text
        let (frontIndex, backIndex) = findBestTranslationPair(analyses: columnAnalyses)
        
        var result = [String?](repeating: nil, count: columns.count)
        if let frontIdx = frontIndex, let backIdx = backIndex {
            result[frontIdx] = "front_text"
            result[backIdx] = "back_text"
            
            // 2. Из оставшихся колонок выбираем hint и description
            let remainingIndices = Set(0..<columns.count)
                .subtracting([frontIdx, backIdx])
            
            // Анализируем оставшиеся колонки
            var bestHintScore = -Double.infinity
            var hintIndex: Int?
            
            for index in remainingIndices {
                let score = scoreForHint(analysis: columnAnalyses[index])
                if score > bestHintScore {
                    bestHintScore = score
                    hintIndex = index
                }
            }
            
            // Присваиваем оставшимся колонкам их типы
            for index in remainingIndices {
                if index == hintIndex {
                    result[index] = "hint"
                } else {
                    result[index] = "description"
                }
            }
        }
        
        return result.map { $0 ?? "unknown" }
    }
    
    private func analyzeColumn(_ column: CsvColumnAnalysis, at position: Int) -> ColumnCharacteristics {
        let values = column.values.filter { !$0.isEmpty }
        guard !values.isEmpty else {
            return ColumnCharacteristics(
                values: [],
                latinRatio: 0,
                nonLatinRatio: 0,
                avgWordLength: 0,
                emptyRatio: 1.0,
                specialCharRatio: 0,
                position: position,
                multilineRatio: 0,
                uniqueValuesRatio: 0,
                wordCount: 0
            )
        }
        
        var latinCharCount = 0
        var nonLatinCharCount = 0
        var totalChars = 0
        let multilineCount = values.filter { $0.contains("\n") }.count
        let uniqueCount = Set(values).count
        
        // Подсчет среднего количества слов
        let avgWordCount = values.reduce(0.0) { sum, value in
            sum + Double(value.split(separator: " ").count)
        } / Double(values.count)
        
        for value in values {
            for scalar in value.unicodeScalars {
                totalChars += 1
                if CharacterSet.latinLetters.contains(scalar) {
                    latinCharCount += 1
                } else if !CharacterSet.whitespaces.contains(scalar) &&
                          !CharacterSet.punctuationCharacters.contains(scalar) {
                    nonLatinCharCount += 1
                }
            }
        }
        
        return ColumnCharacteristics(
            values: values,
            latinRatio: Double(latinCharCount) / Double(max(1, totalChars)),
            nonLatinRatio: Double(nonLatinCharCount) / Double(max(1, totalChars)),
            avgWordLength: column.avgLength,
            emptyRatio: column.emptyRatio,
            specialCharRatio: column.specialCharRatio,
            position: position,
            multilineRatio: Double(multilineCount) / Double(values.count),
            uniqueValuesRatio: Double(uniqueCount) / Double(values.count),
            wordCount: avgWordCount
        )
    }
    
    private func findBestTranslationPair(analyses: [ColumnCharacteristics]) -> (Int?, Int?) {
        var bestScore = -Double.infinity
        var frontIndex: Int?
        var backIndex: Int?
        
        for i in 0..<analyses.count {
            for j in 0..<analyses.count where i != j {
                let score = scoreTranslationPair(
                    potential_front: analyses[i],
                    potential_back: analyses[j]
                )
                
                if score > bestScore {
                    bestScore = score
                    frontIndex = i
                    backIndex = j
                }
            }
        }
        
        return (frontIndex, backIndex)
    }
    
    private func scoreTranslationPair(potential_front: ColumnCharacteristics, potential_back: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // 1. Разные системы письма (самый важный фактор)
        if potential_front.isMainlyLatin && potential_back.isMainlyNonLatin {
            score += 15.0
        }
        
        // 2. Похожая структура данных
        // - Похожее количество уникальных значений
        let uniquenessDiff = abs(potential_front.uniqueValuesRatio - potential_back.uniqueValuesRatio)
        score -= uniquenessDiff * 5.0
        
        // - Похожий процент пустых значений
        let emptyDiff = abs(potential_front.emptyRatio - potential_back.emptyRatio)
        score -= emptyDiff * 5.0
        
        // 3. Характеристики текста перевода
        // - Обычно это одиночные слова или короткие фразы
        if potential_front.wordCount < 3 && potential_back.wordCount < 3 {
            score += 3.0
        }
        
        // - Редко содержат переносы строк
        score -= (potential_front.multilineRatio + potential_back.multilineRatio) * 5.0
        
        // 4. Позиционный фактор (небольшой бонус если колонки рядом)
        let positionDiff = abs(potential_front.position - potential_back.position)
        score += 1.0 / Double(positionDiff + 1)
        
        return score
    }
    
    private func scoreForHint(analysis: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // Hint обычно содержит короткие фразы
        if analysis.avgWordLength < 30 {
            score += 3.0
        }
        
        // Hint может иметь повторяющиеся значения
        if analysis.uniqueValuesRatio < 0.8 {
            score += 2.0
        }
        
        // Hint редко содержит переносы строк
        score -= analysis.multilineRatio * 5.0
        
        // Hint обычно содержит одно-два слова
        if analysis.wordCount <= 2 {
            score += 2.0
        }
        
        return score
    }
}

extension CharacterSet {
    static let latinLetters: CharacterSet = {
        var chars = CharacterSet.lowercaseLetters
        chars.insert(charactersIn: "A"..."Z")
        return chars
    }()
}
