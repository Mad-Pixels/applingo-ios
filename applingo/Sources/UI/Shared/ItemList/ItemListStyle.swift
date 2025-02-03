import SwiftUI

// MARK: - ItemListStyle
/// Defines the styling parameters for the ItemList components.
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
    /// Returns a themed style based on the provided AppTheme.
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
