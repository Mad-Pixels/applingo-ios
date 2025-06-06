import SwiftUI

/// Data model representing a background shape.
struct BackgroundGameModeModelShape: Identifiable {
    let id: UUID
    
    var position: CGPoint
    var opacity: Double
    var size: CGFloat
    var color: Color
}
