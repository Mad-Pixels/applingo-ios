import Foundation

protocol GameSpecialBonus {
    var id: String { get }
    var name: String { get }
    
    var scoreBonus: Int { get }
    var penaltyBonus: Int { get }
}
