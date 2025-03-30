import SwiftUI

struct ItemToggleStyle {
    // Appearance Properties
    let tintColor: Color
    
    // Layout Properties
    let spacing: CGFloat
    let showHeader: Bool
}

extension ItemToggleStyle {
    static func themed(_ theme: AppTheme) -> ItemToggleStyle {
        ItemToggleStyle(
            tintColor: theme.accentPrimary,
            spacing: 8,
            showHeader: true
        )
    }
}
