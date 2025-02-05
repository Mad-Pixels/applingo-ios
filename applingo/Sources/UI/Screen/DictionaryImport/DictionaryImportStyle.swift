import SwiftUI

/// Defines the styling properties for the Dictionary Import view.
final class DictionaryImportStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let accentColor: Color
    let descriptionColor: Color
    let textColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    // Additional text style properties
    let titleFont: Font
    let textFont: Font
    let descriptionFont: Font
    let tagFont: Font
    
    // MARK: - Initialization
    
    init(backgroundColor: Color,
         accentColor: Color,
         descriptionColor: Color,
         textColor: Color,
         padding: EdgeInsets,
         spacing: CGFloat,
         sectionSpacing: CGFloat,
         titleFont: Font,
         textFont: Font,
         descriptionFont: Font,
         tagFont: Font
    ) {
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.descriptionColor = descriptionColor
        self.textColor = textColor
        self.padding = padding
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
        self.titleFont = titleFont
        self.textFont = textFont
        self.descriptionFont = descriptionFont
        self.tagFont = tagFont
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
            descriptionColor: theme.textPrimary,
            textColor: theme.textSecondary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24,
            sectionSpacing: 16,
            titleFont: .system(size: 48, weight: .bold),
            textFont: .system(size: 14, weight: .bold),
            descriptionFont: .system(size: 18, weight: .bold),
            tagFont: .system(size: 12)
        )
    }
}
