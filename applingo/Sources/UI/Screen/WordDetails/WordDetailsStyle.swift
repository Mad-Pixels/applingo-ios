import SwiftUI

final class WordDetailsStyle: ObservableObject {
    let backgroundColor: Color
    let sectionBackgroundColor: Color
    let accentColor: Color
    let disabledColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    init(
        backgroundColor: Color,
        sectionBackgroundColor: Color,
        accentColor: Color,
        disabledColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.sectionBackgroundColor = sectionBackgroundColor
        self.accentColor = accentColor
        self.disabledColor = disabledColor
        self.padding = padding
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
    }
    
    static func themed(_ theme: AppTheme) -> WordDetailsStyle {
        WordDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            sectionBackgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            disabledColor: theme.textSecondary.opacity(0.5),
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24, // Увеличенный отступ между секциями
            sectionSpacing: 16  // Отступ внутри секций
        )
    }
}
