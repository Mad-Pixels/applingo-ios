import SwiftUI

final class DictionaryImportStyle: ObservableObject {
    let backgroundColor: Color
    let accentColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    init(
        backgroundColor: Color,
        accentColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.padding = padding
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
    }
}

extension DictionaryImportStyle {
    static func themed(_ theme: AppTheme) -> DictionaryImportStyle {
        DictionaryImportStyle(
            backgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24,
            sectionSpacing: 16
        )
    }
}
