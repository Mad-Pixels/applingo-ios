import SwiftUI

struct ItemsListStyle {
    let backgroundColor: Color
    let loadingColor: Color
    let errorColor: Color
    let spacing: CGFloat
    let loadingSize: CGFloat
    let padding: EdgeInsets
}

extension ItemsListStyle {
    static func themed(_ theme: AppTheme) -> ItemsListStyle {
        ItemsListStyle(
            backgroundColor: theme.backgroundPrimary,
            loadingColor: theme.accentPrimary,
            errorColor: theme.error,
            spacing: 16,
            loadingSize: 1.5,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        )
    }
}
