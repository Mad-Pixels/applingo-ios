protocol GameProtocol {
    // Базовые характеристики игры
    var type: GameType { get }
    var minimumWordsRequired: Int { get }
    var availableModes: [GameModeEnum] { get }
    
    // Состояние и условия
    var isReadyToPlay: Bool { get }
    
    // Действия
    func start(mode: GameModeEnum)
    func end()
}
