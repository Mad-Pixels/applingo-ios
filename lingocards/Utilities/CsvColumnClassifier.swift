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
        let position: Int
        
        // Основные метрики
        let avgLength: Double
        let lengthDeviation: Double  // Стандартное отклонение длины
        let uniqueRatio: Double      // Процент уникальных значений
        let wordCount: Double        // Среднее количество слов
        let maxWordLength: Double    // Максимальная длина слова
        let emptyRatio: Double
        let multilineRatio: Double
        let specialCharRatio: Double
        
        // Паттерны значений
        let hasRepetitiveValues: Bool    // Есть ли частые повторы значений
        let consistentWordCount: Bool    // Одинаковое ли количество слов
        let containsUrls: Bool           // Есть ли URL'ы
        let containsPunctuation: Bool    // Есть ли знаки препинания
        
        init(values: [String], position: Int) {
            self.values = values
            self.position = position
            
            // Вычисляем базовые метрики длины
            let lengths = values.map { $0.count }
            let totalLength = lengths.reduce(0, +)
            let avg = Double(totalLength) / Double(max(1, values.count))
            self.avgLength = avg
            
            // Вычисляем стандартное отклонение
            let variance = lengths.map {
                let diff = Double($0) - avg
                return diff * diff
            }.reduce(0, +) / Double(max(1, values.count))
            let deviation = sqrt(variance)
            self.lengthDeviation = deviation
            
            // Уникальность
            let uniqueCount = Set(values).count
            self.uniqueRatio = Double(uniqueCount) / Double(max(1, values.count))
            
            // Анализ слов
            let wordCounts = values.map { $0.split(separator: " ").count }
            self.wordCount = Double(wordCounts.reduce(0, +)) / Double(max(1, values.count))
            self.maxWordLength = Double(values.flatMap { $0.split(separator: " ") }.map { $0.count }.max() ?? 0)
            
            // Специальные характеристики
            self.emptyRatio = Double(values.filter { $0.isEmpty }.count) / Double(max(1, values.count))
            self.multilineRatio = Double(values.filter { $0.contains("\n") }.count) / Double(max(1, values.count))
            
            // Специальные символы (исключая пробелы и базовую пунктуацию)
            let specialChars = values.joined().unicodeScalars.filter { scalar in
                !CharacterSet.letters.contains(scalar) &&
                !CharacterSet.whitespaces.contains(scalar) &&
                !CharacterSet.punctuationCharacters.contains(scalar)
            }.count
            self.specialCharRatio = Double(specialChars) / Double(max(1, values.joined().count))
            
            // Анализ паттернов
            let valueCounts = Dictionary(grouping: values) { $0 }.mapValues { $0.count }
            self.hasRepetitiveValues = valueCounts.values.contains { $0 > values.count / 3 }
            self.consistentWordCount = Set(wordCounts).count <= 2
            self.containsUrls = values.contains { $0.contains("http") || $0.contains("www.") }
            self.containsPunctuation = values.contains { $0.contains { $0.isPunctuation } }
        }
    }
    
    func classifyColumns() -> [String] {
        guard columns.count >= 2 else { return [] }
        
        let analyses = columns.enumerated().map { index, column in
            ColumnCharacteristics(values: column.values, position: index)
        }
        
        // 1. Находим наиболее вероятную пару translation columns
        let (frontIndex, backIndex) = findTranslationPair(analyses: analyses)
        
        var result = [String?](repeating: nil, count: columns.count)
        if let frontIdx = frontIndex, let backIdx = backIndex {
            result[frontIdx] = "front_text"
            result[backIdx] = "back_text"
            
            // 2. Определяем hint и description среди оставшихся
            let remainingIndices = Set(0..<columns.count)
                .subtracting([frontIdx, backIdx])
            
            for index in remainingIndices {
                let isHint = scoreForHint(col: analyses[index]) > scoreForDescription(col: analyses[index])
                result[index] = isHint ? "hint" : "description"
            }
        }
        
        return result.map { $0 ?? "unknown" }
    }
    
    private func findTranslationPair(analyses: [ColumnCharacteristics]) -> (Int?, Int?) {
        var bestScore = -Double.infinity
        var frontIndex: Int?
        var backIndex: Int?
        
        for i in 0..<analyses.count {
            for j in i+1..<analyses.count {
                let score = scoreTranslationPair(col1: analyses[i], col2: analyses[j])
                if score > bestScore {
                    bestScore = score
                    frontIndex = i
                    backIndex = j
                }
            }
        }
        
        return (frontIndex, backIndex)
    }
    
    private func scoreTranslationPair(col1: ColumnCharacteristics, col2: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // 1. Сходство паттернов между колонками
        score += similarityScore(col1: col1, col2: col2) * 5.0
        
        // 2. Характеристики, типичные для пар перевода
        let translationPairScore = translationColumnScore(col: col1) +
                                 translationColumnScore(col: col2)
        score += translationPairScore
        
        // 3. Штрафы за нежелательные характеристики
        let penalties = calculatePenalties(col1: col1, col2: col2)
        score -= penalties
        
        return score
    }
    
    private func similarityScore(col1: ColumnCharacteristics, col2: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // Похожая средняя длина (с учетом возможной разницы в языках)
        let lengthRatio = min(col1.avgLength, col2.avgLength) / max(col1.avgLength, col2.avgLength)
        score += lengthRatio * 2.0
        
        // Похожее количество уникальных значений
        let uniqueRatio = min(col1.uniqueRatio, col2.uniqueRatio) / max(col1.uniqueRatio, col2.uniqueRatio)
        score += uniqueRatio * 3.0
        
        // Похожая структура слов
        if col1.consistentWordCount && col2.consistentWordCount {
            score += 2.0
        }
        
        return score
    }
    
    private func translationColumnScore(col: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // Высокая уникальность значений
        if col.uniqueRatio > 0.9 {
            score += 3.0
        }
        
        // Короткие значения
        if col.avgLength < 30 {
            score += 2.0
        }
        
        // Консистентное количество слов
        if col.consistentWordCount {
            score += 2.0
        }
        
        // Отсутствие специальных символов
        if col.specialCharRatio < 0.1 {
            score += 1.0
        }
        
        return score
    }
    
    private func calculatePenalties(col1: ColumnCharacteristics, col2: ColumnCharacteristics) -> Double {
        var penalties = 0.0
        
        // Штраф за URLs
        if col1.containsUrls || col2.containsUrls {
            penalties += 10.0
        }
        
        // Штраф за мультистрочность
        penalties += (col1.multilineRatio + col2.multilineRatio) * 5.0
        
        // Штраф за пустые значения
        penalties += (col1.emptyRatio + col2.emptyRatio) * 5.0
        
        // Штраф за большое расхождение в структуре
        let lengthDeviationDiff = abs(col1.lengthDeviation - col2.lengthDeviation)
        penalties += lengthDeviationDiff * 2.0
        
        return penalties
    }
    
    private func scoreForHint(col: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // Обычно короче description
        if col.avgLength < 30 {
            score += 2.0
        }
        
        // Может иметь повторяющиеся значения
        if col.hasRepetitiveValues {
            score += 2.0
        }
        
        // Обычно одно-два слова
        if col.wordCount <= 2 {
            score += 1.0
        }
        
        return score
    }
    
    private func scoreForDescription(col: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // Обычно длиннее hint
        if col.avgLength > 30 {
            score += 2.0
        }
        
        // Больше уникальных значений
        if col.uniqueRatio > 0.9 {
            score += 1.0
        }
        
        // Может содержать знаки препинания
        if col.containsPunctuation {
            score += 1.0
        }
        
        return score
    }
}
