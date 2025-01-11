import SwiftUI

final class ScreenWordDetailStyle: ObservableObject {
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

extension ScreenWordDetailStyle {
    static func themed(_ theme: AppTheme) -> ScreenWordDetailStyle {
        ScreenWordDetailStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            spacing: 16,
            sectionSpacing: 16
        )
    }
}
