import SwiftUI

/// Defines styling properties for the WordDetails view.
final class WordDetailsStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let sectionBackgroundColor: Color
    let accentColor: Color
    let disabledColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    // MARK: - Initializer
    
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
    
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> WordDetailsStyle {
        WordDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            sectionBackgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            disabledColor: theme.textSecondary.opacity(0.5),
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24,
            sectionSpacing: 16
        )
    }
}
