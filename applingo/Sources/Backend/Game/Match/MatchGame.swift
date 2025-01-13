import SwiftUI

class MatchGame: GameProtocol {
    var type: GameType = .match
    var minimumWordsRequired: Int = 12
    var availableModes: [GameModeEnum] = [.practice, .survival, .timeAttack]
    var isReadyToPlay: Bool { true }
    
    func start(mode: GameModeEnum) {}
    func end() {}
}


struct MatchHuntGameContent: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("Match Hunt Game Content")
    }
}
