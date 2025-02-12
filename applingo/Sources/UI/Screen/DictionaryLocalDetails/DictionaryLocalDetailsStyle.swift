import SwiftUI

/// Defines styling properties for the Dictionary Local Details view.
final class DictionaryLocalDetailsStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let paddingBlock: CGFloat
    let spacing: CGFloat
    let sectionSpacing: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `DictionaryLocalDetailsStyle`.
    /// - Parameters:
    ///   - backgroundColor: The background color of the view.
    ///   - padding: The overall padding around the content.
    ///   - paddingBlock: The horizontal padding used for internal blocks.
    ///   - spacing: The spacing between individual UI elements.
    ///   - sectionSpacing: The spacing between sections.
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        paddingBlock: CGFloat,
        spacing: CGFloat,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.paddingBlock = paddingBlock
        self.spacing = spacing
        self.sectionSpacing = sectionSpacing
    }
}

// MARK: - Themed Style Extension
extension DictionaryLocalDetailsStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `DictionaryLocalDetailsStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> DictionaryLocalDetailsStyle {
        DictionaryLocalDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            paddingBlock: 8,
            spacing: 24,
            sectionSpacing: 16
        )
    }
}
