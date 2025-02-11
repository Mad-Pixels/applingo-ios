import SwiftUI

/// Defines styling properties for the WordAddManual view.
final class WordAddManualStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let spacing: CGFloat
    let padding: EdgeInsets
    let paddingBlock: CGFloat
    let sectionSpacing: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `WordAddManualStyle`.
    /// - Parameters:
    ///   - backgroundColor: The background color for the view.
    ///   - spacing: The spacing between individual elements.
    ///   - padding: The overall padding around the content.
    ///   - paddingBlock: The horizontal padding for blocks of content.
    ///   - sectionSpacing: The spacing between sections.
    init(
        backgroundColor: Color,
        spacing: CGFloat,
        padding: EdgeInsets,
        paddingBlock: CGFloat,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.sectionSpacing = sectionSpacing
        self.paddingBlock = paddingBlock
        self.spacing = spacing
        self.padding = padding
    }
}

// MARK: - Themed Style Extension
extension WordAddManualStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `WordAddManualStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> WordAddManualStyle {
        WordAddManualStyle(
            backgroundColor: theme.backgroundPrimary,
            spacing: 16,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16),
            paddingBlock: 8,
            sectionSpacing: 12
        )
    }
}
