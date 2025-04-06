import SwiftUI

struct OverlayIconStyle {
    // Appearance
    let iconSize: CGFloat
    let iconWeight: Font.Weight
    let iconOpacity: Double
    let shadowRadius: CGFloat
    let animation: Animation
}

extension OverlayIconStyle {
    static func themed(_ theme: AppTheme) -> OverlayIconStyle {
        OverlayIconStyle(
            iconSize: 80,
            iconWeight: .bold,
            iconOpacity: 1.0,
            shadowRadius: 5,
            animation: .spring(response: 0.35, dampingFraction: 0.7)
        )
    }
}
