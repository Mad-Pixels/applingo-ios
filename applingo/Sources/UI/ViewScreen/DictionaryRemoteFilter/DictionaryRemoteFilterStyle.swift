import SwiftUI

final class DictionaryRemoteFilterStyle: ObservableObject {
    let backgroundColor: Color
    let spacing: CGFloat
    let padding: EdgeInsets
    
    init(
        backgroundColor: Color,
        spacing: CGFloat,
        padding: EdgeInsets
    ) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
    }
}

extension DictionaryRemoteFilterStyle {
    static func themed(_ theme: AppTheme) -> DictionaryRemoteFilterStyle {
        DictionaryRemoteFilterStyle(
            backgroundColor: theme.backgroundPrimary,
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        )
    }
}
