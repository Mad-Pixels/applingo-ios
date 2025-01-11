import SwiftUI

final class ScreenWordAddStyle: ObservableObject {
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

extension ScreenWordAddStyle {
    static func themed(_ theme: AppTheme) -> ScreenWordAddStyle {
        ScreenWordAddStyle(
            backgroundColor: theme.backgroundPrimary,
            spacing: 16,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            sectionSpacing: 12
        )
    }
}
