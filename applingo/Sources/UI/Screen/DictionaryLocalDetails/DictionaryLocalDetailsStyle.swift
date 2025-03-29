import SwiftUI

final class DictionaryLocalDetailsStyle: ObservableObject {
    // Colors
    let backgroundColor: Color

    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat
    let sectionSpacing: CGFloat

    // Internal Blocks
    let paddingBlock: CGFloat

    /// Initializes the DictionaryLocalDetailsStyle.
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

extension DictionaryLocalDetailsStyle {
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
