import SwiftUI

struct ItemListStyle {
    let backgroundColor: Color
    let ontapColor: Color
    let loadingColor: Color
    let errorColor: Color
    let spacing: CGFloat
    let loadingSize: CGFloat
    let padding: EdgeInsets
}

extension ItemListStyle {
    static func themed(_ theme: AppTheme) -> ItemListStyle {
        ItemListStyle(
            backgroundColor: theme.backgroundPrimary,
            ontapColor: theme.cardBorder,
            loadingColor: theme.accentPrimary,
            errorColor: theme.error,
            spacing: 16,
            loadingSize: 1.5,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        )
    }
}
