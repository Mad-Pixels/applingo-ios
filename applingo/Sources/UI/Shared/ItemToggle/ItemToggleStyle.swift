import SwiftUI

struct ItemToggleStyle {
    let titleColor: Color
    let tintColor: Color
    let spacing: CGFloat
    let showHeader: Bool
}

extension ItemToggleStyle {
    static func themed(_ theme: AppTheme) -> ItemToggleStyle {
        ItemToggleStyle(
            titleColor: theme.textPrimary,
            tintColor: theme.accentPrimary,
            spacing: 8,
            showHeader: true
        )
    }
}
