import SwiftUI

struct GameSpecialBoardModel: Identifiable {
    let id: UUID
    var position: CGPoint
    var velocity: CGPoint
    let size: CGFloat
    let color: Color
    var trailPositions: [CGPoint]
}
