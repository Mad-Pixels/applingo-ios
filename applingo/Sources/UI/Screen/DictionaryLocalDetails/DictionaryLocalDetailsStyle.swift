import SwiftUI

/// Defines styling properties for the Dictionary Local Details view.
final class DictionaryLocalDetailsStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    // MARK: - Initializer
    
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

// MARK: - Themed Style Extension

extension DictionaryLocalDetailsStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> DictionaryLocalDetailsStyle {
        DictionaryLocalDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24,
            sectionSpacing: 16
        )
    }
}
