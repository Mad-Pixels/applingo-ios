import Foundation

enum GameSwipeStatusModel {
    case none
    case left
    case right
}

enum GameDragStateModel {
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

struct GameVerifyCardModel {
    let frontWord: WordItemModel
    let backText: String
    let isMatch: Bool
    let isSpecial: Bool
    
    init(frontWord: WordItemModel, backText: String, isMatch: Bool, isSpecial: Bool) {
        self.frontWord = frontWord
        self.backText = backText
        self.isMatch = isMatch
        self.isSpecial = isSpecial
    }
}

struct GameVerifyResultModel: GameResultProtocol {
    let word: WordItemModel
    let isCorrect: Bool
    let score: Int
    let responseTime: TimeInterval
    let isSpecial: Bool
    let hintPenalty: Int
    
    init(word: WordItemModel, isCorrect: Bool, score: Int, responseTime: TimeInterval, isSpecial: Bool, hintPenalty: Int) {
        self.word = word
        self.isCorrect = isCorrect
        self.score = score
        self.responseTime = responseTime
        self.isSpecial = isSpecial
        self.hintPenalty = hintPenalty
    }
}

struct GameScoreAnimationModel: Identifiable, Equatable {
    let id = UUID()
    let points: Int
    let reason: ScoreAnimationReason
    
    static func == (lhs: GameScoreAnimationModel, rhs: GameScoreAnimationModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.points == rhs.points &&
        lhs.reason == rhs.reason
    }
}
