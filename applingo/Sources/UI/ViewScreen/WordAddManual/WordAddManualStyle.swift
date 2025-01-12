import SwiftUI

final class WordAddManualStyle: ObservableObject {
    let backgroundColor: Color
    let spacing: CGFloat
    let padding: EdgeInsets
    let sectionSpacing: CGFloat
    
    init(
        backgroundColor: Color,
        spacing: CGFloat,
        padding: EdgeInsets,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
        self.sectionSpacing = sectionSpacing
    }
}

extension WordAddManualStyle {
    static func themed(_ theme: AppTheme) -> WordAddManualStyle {
        WordAddManualStyle(
            backgroundColor: theme.backgroundPrimary,
            spacing: 16,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            sectionSpacing: 12
        )
    }
}
