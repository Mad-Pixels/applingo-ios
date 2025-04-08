import SwiftUI

protocol GameSpecialBonus {
    var id: String { get }
    var name: String { get }
    var scoreBonus: Int { get }
    var penaltyBonus: Int { get }

    var backgroundColor: DynamicPatternModel { get }
    var borderColor: DynamicPatternModel { get }
    var icon: Image? { get }

    var backgroundEffectView: AnyView { get }
}
