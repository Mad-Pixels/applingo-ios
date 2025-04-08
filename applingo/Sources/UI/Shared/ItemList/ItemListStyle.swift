import SwiftUI

struct ItemListStyle {
    // Color Properties
    let backgroundColor: Color
    let ontapColor: Color
    let loadingColor: Color
    let errorColor: Color

    // Layout Properties
    let spacing: CGFloat
    let padding: EdgeInsets

    // Loading Indicator Properties
    let loadingSize: CGFloat

    // Row Specific Properties
    let rowHorizontalPadding: CGFloat
    let rowVerticalPadding: CGFloat
    let rowCornerRadius: CGFloat
    let rowListInsets: EdgeInsets
}

extension ItemListStyle {
    static func themed(_ theme: AppTheme) -> ItemListStyle {
        ItemListStyle(
            backgroundColor: theme.backgroundPrimary,
            ontapColor: theme.cardBorder,
            loadingColor: theme.accentPrimary,
            errorColor: theme.error,
            spacing: 16,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            loadingSize: 1.5,
            rowHorizontalPadding: 8,
            rowVerticalPadding: 8,
            rowCornerRadius: 12,
            rowListInsets: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        )
    }
}
