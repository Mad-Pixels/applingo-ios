import SwiftUI

class BaseGameStats: AbstractGameStats {
    var score: Int = 0
    var accuracy: Double = 0
    var perfectStreaks: Int = 0
    var averageResponseTime: TimeInterval = 0
}
