import SwiftUI

final class DictionaryImportStyle: ObservableObject {
    // Colors
    let backgroundColor: Color
    let accentColor: Color
    let descriptionColor: Color
    let textColor: Color
    
    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat
    
    // Typography
    let titleFont: Font
    let textFont: Font
    let descriptionFont: Font
    let tagFont: Font
    
    /// Initializes a new instance of `DictionaryImportStyle`.
    /// - Parameters:
    ///   - backgroundColor: The background color for the view.
    ///   - accentColor: The accent color for highlights.
    ///   - descriptionColor: The color used for descriptive text.
    ///   - textColor: The color used for regular text.
    ///   - padding: The padding around the content.
    ///   - spacing: The spacing between individual UI elements.
    ///   - sectionSpacing: The spacing between sections.
    ///   - titleFont: The font used for titles.
    ///   - textFont: The font used for body text.
    ///   - descriptionFont: The font used for descriptive text.
    ///   - tagFont: The font used for tags.
    init(
        backgroundColor: Color,
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

extension DictionaryImportStyle {
    static func themed(_ theme: AppTheme) -> DictionaryImportStyle {
        DictionaryImportStyle(
            backgroundColor: theme.backgroundPrimary,
            accentColor: theme.accentPrimary,
            descriptionColor: theme.textPrimary,
            textColor: theme.textSecondary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            spacing: 24,
            sectionSpacing: 16,
            titleFont: .system(size: 48, weight: .bold),
            textFont: .system(size: 14, weight: .bold),
            descriptionFont: .system(size: 18, weight: .bold),
            tagFont: .system(size: 12)
        )
    }
}
