protocol AbstractGame {
    // Base part
    var type: GameType { get }
    var minimumWordsRequired: Int { get }
    var availableModes: [GameModeEnum] { get }
    
    // State
    var isReadyToPlay: Bool { get }
    
    // Action
    func start(mode: GameModeEnum)
    func end()
}
