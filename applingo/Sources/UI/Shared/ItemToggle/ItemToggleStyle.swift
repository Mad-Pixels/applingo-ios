import SwiftUI

struct ItemToggleStyle {
    let titleColor: Color
    let headerColor: Color
    let tintColor: Color
    let backgroundColor: Color
    let spacing: CGFloat
    let showHeader: Bool
}

extension ItemToggleStyle {
    static func themed(_ theme: AppTheme) -> ItemToggleStyle {
        ItemToggleStyle(
            titleColor: theme.textPrimary,
            headerColor: theme.textSecondary,
            tintColor: theme.accentPrimary,
            backgroundColor: .clear,
            spacing: 8,
            showHeader: true
        )
    }
    
    static func themedCompact(_ theme: AppTheme) -> ItemToggleStyle {
        ItemToggleStyle(
            titleColor: theme.textPrimary,
            headerColor: theme.textSecondary,
            tintColor: theme.accentPrimary,
            backgroundColor: .clear,
            spacing: 4,
            showHeader: false
        )
    }
}
