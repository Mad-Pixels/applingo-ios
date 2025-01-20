import SwiftUI

protocol AbstractGame {
    // Base part
    var availableModes: [GameModeEnum] { get }
    var minimumWordsRequired: Int { get }
    var theme: GameTheme { get }
    var type: GameType { get }
    
    // State
    var isReadyToPlay: Bool { get }
    
    // Action
    func start(mode: GameModeEnum)
    func end()
    
    // View
    @ViewBuilder
    func makeView() -> AnyView
}
