import SwiftUI

struct DictionaryRowStyle {
    let titleColor: Color
    let subtitleColor: Color
    let backgroundColor: Color
    let titleFont: Font
    let subtitleFont: Font
    let padding: EdgeInsets
}

extension DictionaryRowStyle {
    static func themed(_ theme: AppTheme) -> DictionaryRowStyle {
        DictionaryRowStyle(
            titleColor: theme.textPrimary,
            subtitleColor: theme.textSecondary,
            backgroundColor: theme.backgroundPrimary,
            titleFont: .headline,
            subtitleFont: .subheadline,
            padding: EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        )
    }
}
