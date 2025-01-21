import SwiftUI

protocol AbstractGameMode {
    var type: GameModeType { get }
    var restrictions: GameModeRestrictions { get }
    
    func validateGameState(_ state: GameState) -> Bool
    func shouldEndGame(_ state: GameState) -> Bool
}
