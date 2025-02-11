import SwiftUI

/// Defines styling properties for the Dictionary Remote List view.
final class DictionaryRemoteListStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let titleFont: Font
    
    // MARK: - Initializer
    
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat,
        titleFont: Font
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
        self.titleFont = titleFont
    }
}

// MARK: - Themed Style Extension

extension DictionaryRemoteListStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> DictionaryRemoteListStyle {
        DictionaryRemoteListStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16),
            spacing: 16,
            titleFont: .system(size: 24, weight: .bold)
        )
    }
}
