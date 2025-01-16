import SwiftUI

final class DictionaryLocalDetailsStyle: ObservableObject {
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
   
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
    }
}

extension DictionaryLocalDetailsStyle {
    static func themed(_ theme: AppTheme) -> DictionaryLocalDetailsStyle {
        DictionaryLocalDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24,
            sectionSpacing: 16
        )
    }
}
