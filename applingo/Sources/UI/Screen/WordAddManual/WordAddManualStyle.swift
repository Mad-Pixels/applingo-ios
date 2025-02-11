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

// MARK: - Themed Style Extension

extension WordAddManualStyle {
    /// Returns a themed style based on the current application theme.
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
