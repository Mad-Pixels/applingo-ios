import Foundation

protocol GameSpecialBonus {
    var id: String { get }
    var title: String { get }
    
    func applyBonus() -> String
}
