import SwiftUI

class SwipeGame: GameProtocol {
    var type: GameType = .swipe
    var minimumWordsRequired: Int = 12
    var availableModes: [GameModeEnum] = [.practice, .survival, .timeAttack]
    var isReadyToPlay: Bool { true }
    
    func start(mode: GameModeEnum) {}
    func end() {}
}


struct VerifyItGameContent: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Text("Verify It Game Content")
    }
}
