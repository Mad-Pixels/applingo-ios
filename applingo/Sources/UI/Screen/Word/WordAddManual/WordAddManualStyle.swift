import SwiftUI

final class WordAddManualStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color

    // Layout Properties
    let spacing: CGFloat
    let padding: EdgeInsets
    let paddingBlock: CGFloat
    let sectionSpacing: CGFloat

    /// Initializes the WordAddManualStyle.
    /// - Parameters:
    ///   - backgroundColor: The background color for the view.
    ///   - spacing: The spacing between individual elements.
    ///   - padding: The overall padding around the content.
    ///   - paddingBlock: The horizontal padding for content blocks.
    ///   - sectionSpacing: The spacing between sections.
    init(
        backgroundColor: Color,
        spacing: CGFloat,
        padding: EdgeInsets,
        paddingBlock: CGFloat,
        sectionSpacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
        self.paddingBlock = paddingBlock
        self.sectionSpacing = sectionSpacing
    }
}

extension WordAddManualStyle {
    static func themed(_ theme: AppTheme) -> WordAddManualStyle {
        WordAddManualStyle(
            backgroundColor: theme.backgroundPrimary,
            spacing: 16,
            padding: EdgeInsets(top: 12, leading: 16, bottom: 32, trailing: 16),
            paddingBlock: 8,
            sectionSpacing: 12
        )
    }
}
