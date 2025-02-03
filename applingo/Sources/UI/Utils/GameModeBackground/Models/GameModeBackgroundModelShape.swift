import SwiftUI

// MARK: - GameModeBackgroundModelShape
/// Data model representing a background shape.
struct GameModeBackgroundModelShape: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var color: Color
}
