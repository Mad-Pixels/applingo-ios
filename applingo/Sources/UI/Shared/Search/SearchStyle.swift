import SwiftUI

struct AppSearchStyle {
    let backgroundColor: Color
    let textColor: Color
    let placeholderColor: Color
    let iconColor: Color
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let iconSize: CGFloat
    let spacing: CGFloat
}

extension AppSearchStyle {
    static func themed(_ theme: AppTheme) -> AppSearchStyle {
        AppSearchStyle(
            backgroundColor: theme.backgroundSecondary,
            textColor: theme.textPrimary,
            placeholderColor: theme.textSecondary,
            iconColor: theme.textSecondary,
            padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
            cornerRadius: 8,
            iconSize: 20,
            spacing: 8
        )
    }
}
