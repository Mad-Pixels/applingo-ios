import SwiftUI

/// Defines the styling properties for the Dictionary Import view.
final class DictionaryImportStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let accentColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    // MARK: - Initialization
    
    init(backgroundColor: Color,
         accentColor: Color,
         padding: EdgeInsets,
         spacing: CGFloat,
         sectionSpacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.padding = padding
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
    }
}

// MARK: - Themed Style Extension

extension DictionaryImportStyle {
    /// Returns a themed style based on the current app theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A DictionaryImportStyle instance configured for the theme.
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
