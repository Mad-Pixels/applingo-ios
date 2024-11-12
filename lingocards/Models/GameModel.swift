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

struct VerifyCardModel: GameCardModel {
    let id = UUID()
    let frontWord: WordItemModel
    let backText: String
    let isMatch: Bool
    
    static func == (lhs: VerifyCardModel, rhs: VerifyCardModel) -> Bool {
        lhs.id == rhs.id
    }
}

struct VerifyGameResultModel: GameResultProtocol {
    let word: WordItemModel
    let isCorrect: Bool
    let responseTime: TimeInterval
}
