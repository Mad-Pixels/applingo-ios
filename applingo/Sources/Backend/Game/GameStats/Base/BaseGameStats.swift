import SwiftUI

class BaseGameStats: ObservableObject, AbstractGameStats {
    @Published var score: Int = 0
    @Published var perfectStreaks: Int = 0
    @Published var averageResponseTime: TimeInterval = 0
}
