import Foundation

final class GameStateUtilsSurvival: ObservableObject {
    /// The initial number of lives.
    @Published private(set) var initialLives: Int
    
    /// The current number of lives remaining.
    @Published private(set) var lives: Int
    
    /// Callback triggered when lives reach zero.
    var onNoLivesLeft: (() -> Void)?
    
    /// Initializes the GameStateUtilsSurvival.
    /// - Parameter initialLives: The initial number of lives for survival mode.
    init(initialLives: Int) {
        self.initialLives = initialLives
        self.lives = initialLives
    }
    
    /// Decreases the number of lives by one and triggers the callback if lives reach zero.
    final func decreaseLife() {
        lives -= 1
        
        if lives <= 0 {
            Logger.debug("[GameStateUtilsSurvival]: No lives left")
            onNoLivesLeft?()
        }
    }
    
    /// Resets the number of lives to the initial value.
    final func reset() {
        lives = initialLives
    }
}
