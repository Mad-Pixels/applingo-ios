import SwiftUI

final class DictionaryListLocalStyle: ObservableObject {
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
}

extension DictionaryListLocalStyle {
    static func themed(_ theme: AppTheme) -> DictionaryListLocalStyle {
        DictionaryListLocalStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
