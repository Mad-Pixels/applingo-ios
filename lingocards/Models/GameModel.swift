import Foundation

enum SwipeStatusModel {
    case none
    case left
    case right
}

enum DragStateModel {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
}

protocol GameCardModel: Equatable, Identifiable {
    associatedtype WordModel
    var id: UUID { get }
    var frontWord: WordModel { get }
}

struct VerifyCardModel {
    let frontWord: WordItemModel
    let backText: String
    let isMatch: Bool
    let isSpecial: Bool
    
    init(frontWord: WordItemModel, backText: String, isMatch: Bool) {
        self.frontWord = frontWord
        self.backText = backText
        self.isMatch = isMatch
        self.isSpecial = GameSpecialManager.shared.isSpecial(frontWord)
    }
}

struct VerifyGameResultModel: GameResultProtocol {
    let word: WordItemModel
    let isCorrect: Bool
    let score: Int
    let responseTime: TimeInterval
    let isSpecial: Bool
    
    init(word: WordItemModel, isCorrect: Bool, score: Int, responseTime: TimeInterval, isSpecial: Bool) {
        self.word = word
        self.isCorrect = isCorrect
        self.score = score
        self.responseTime = responseTime
        self.isSpecial = isSpecial
    }
}


