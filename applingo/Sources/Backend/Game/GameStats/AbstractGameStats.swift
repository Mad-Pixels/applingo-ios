import SwiftUI

protocol AbstractGameStats {
    var score: Int { get set }
    var perfectStreaks: Int { get set }
    var averageResponseTime: TimeInterval { get set }
}
