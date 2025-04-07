import SwiftUI

protocol GameSpecialBonus {
    var id: String { get }
    var name: String { get }
    
    var scoreBonus: Int { get }
    var penaltyBonus: Int { get }
    
    var backgroundColor: Color { get }
    var borderColor: Color { get }
    var icon: Image? { get }
}
