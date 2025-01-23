import Foundation

struct GameHintState {
    var isShowing: Bool
    var wasUsed: Bool
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

struct GameVerifyResultModel: GameResultProtocol {
    let word: DatabaseModelWord
    let isCorrect: Bool
    let responseTime: TimeInterval
    let isSpecial: Bool
    let hintPenalty: Int
}

protocol GameCardModel: Equatable, Identifiable {
    associatedtype WordModel
    var id: UUID { get }
    var frontWord: WordModel { get }
}

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

struct GameVerifyCardModel {
    let frontWord: DatabaseModelWord
    let backText: String
    let isMatch: Bool
    let isSpecial: Bool
}

struct GameQuizCardModel: Equatable {
    let correctWord: DatabaseModelWord
    let options: [DatabaseModelWord]
    let isReversed: Bool
    let isSpecial: Bool
    
    var questionText: String {
        isReversed ? correctWord.backText : correctWord.frontText
    }
    
    var correctAnswer: DatabaseModelWord {
        correctWord
    }
    
    var hintText: String? {
        correctWord.hint
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

struct MatchCardState {
    var leftWords: [DatabaseModelWord] = []
    var rightWords: [DatabaseModelWord] = []
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

enum GameLetterStyle {
    case option
    case answer
}
