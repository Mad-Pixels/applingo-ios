import SwiftUI

/// Defines styling properties for the Dictionary Remote Details view.
final class DictionaryRemoteDetailsStyle: ObservableObject {
    
    // MARK: - Properties
    
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    // MARK: - Initializer
    
    init(backgroundColor: Color, padding: EdgeInsets, spacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
    }
}

// MARK: - Themed Style Extension

extension DictionaryRemoteDetailsStyle {
    /// Returns a themed style based on the current application theme.
    static func themed(_ theme: AppTheme) -> DictionaryRemoteDetailsStyle {
        DictionaryRemoteDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            spacing: 16
        )
    }
}
