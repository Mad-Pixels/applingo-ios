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

struct GameQuizCardModel: Equatable {
    let correctWord: WordItemModel
    let options: [WordItemModel]
    let isReversed: Bool
    let isSpecial: Bool
    
    var questionText: String {
        isReversed ? correctWord.backText : correctWord.frontText
    }
    
    var correctAnswer: WordItemModel {
        correctWord
    }
    
    var hintText: String? {
        correctWord.hint
    }
}

struct MatchCardState {
    var leftWords: [WordItemModel] = []
    var rightWords: [WordItemModel] = []
    var matchedIndices: Set<Int> = []
    var selectedLeftIndex: Int?
    var selectedRightIndex: Int?
    var isProcessingMatch: Bool = false
    
    mutating func reset() {
        matchedIndices.removeAll()
        selectedLeftIndex = nil
        selectedRightIndex = nil
        isProcessingMatch = false
    }
    
    var hasSelectedPair: Bool {
        selectedLeftIndex != nil && selectedRightIndex != nil
    }
    
    func canSelectLeft(_ index: Int) -> Bool {
        !isProcessingMatch && !matchedIndices.contains(index) && selectedLeftIndex != index
    }
    
    func canSelectRight(_ index: Int) -> Bool {
        !isProcessingMatch && !matchedIndices.contains(index + leftWords.count) && selectedRightIndex != index
    }
}

struct QuizCardState {
    var selectedOptionId: Int?
    var isInteractionDisabled: Bool
    var showCorrectAnswer: Bool
    
    static let initial = QuizCardState(
        selectedOptionId: nil,
        isInteractionDisabled: false,
        showCorrectAnswer: false
    )
}

struct GameVerifyResultModel: GameResultProtocol {
    let word: WordItemModel
    let isCorrect: Bool
    let responseTime: TimeInterval
    let isSpecial: Bool
    let hintPenalty: Int
    
    init(word: WordItemModel, isCorrect: Bool,  responseTime: TimeInterval, isSpecial: Bool, hintPenalty: Int) {
        self.word = word
        self.isCorrect = isCorrect
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

struct GameHintState {
    var isShowing: Bool
    var wasUsed: Bool
}
