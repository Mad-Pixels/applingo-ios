import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

protocol GameResultProtocol {
    var word: WordItemModel { get }
    var isCorrect: Bool { get }
    var responseTime: TimeInterval { get }
}

enum GameMode {
    case practice
    case survival
    case timeAttack
}
