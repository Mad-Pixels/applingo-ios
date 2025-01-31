import SwiftUI

/// Defines styling properties for the Dictionary Local List view.
final class DictionaryLocalListStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    // MARK: - Initializer
    
    init(spacing: CGFloat, padding: EdgeInsets, backgroundColor: Color) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
}

// MARK: - Themed Style Extension

extension DictionaryLocalListStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> DictionaryLocalListStyle {
        DictionaryLocalListStyle(
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
