import SwiftUI

struct AppToggleStyle {
    let titleColor: Color
    let headerColor: Color
    let tintColor: Color
    let backgroundColor: Color
    let spacing: CGFloat
    let showHeader: Bool
}

extension AppToggleStyle {
    static func themed(_ theme: AppTheme) -> AppToggleStyle {
        AppToggleStyle(
            titleColor: theme.textPrimary,
            headerColor: theme.textSecondary,
            tintColor: theme.accentPrimary,
            backgroundColor: .clear,
            spacing: 8,
            showHeader: true
        )
    }
    
    static func themedCompact(_ theme: AppTheme) -> AppToggleStyle {
        AppToggleStyle(
            titleColor: theme.textPrimary,
            headerColor: theme.textSecondary,
            tintColor: theme.accentPrimary,
            backgroundColor: .clear,
            spacing: 4,
            showHeader: false
        )
    }
}
