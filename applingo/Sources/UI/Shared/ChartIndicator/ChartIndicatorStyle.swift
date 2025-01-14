import SwiftUI

struct ChartIndicatorStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let height: CGFloat
    let cornerRadius: CGFloat
    let animation: Animation
    
    static func themed(_ theme: AppTheme) -> ChartIndicatorStyle {
        ChartIndicatorStyle(
            backgroundColor: theme.backgroundSecondary,
            foregroundColor: theme.accentPrimary,
            height: 4,
            cornerRadius: 2,
            animation: .spring(response: 0.3)
        )
    }
}
