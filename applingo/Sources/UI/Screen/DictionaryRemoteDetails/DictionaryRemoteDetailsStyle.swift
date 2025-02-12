import SwiftUI

/// Defines styling properties for the Dictionary Remote Details view.
final class DictionaryRemoteDetailsStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `DictionaryRemoteDetailsStyle`.
    /// - Parameters:
    ///   - backgroundColor: The background color for the view.
    ///   - padding: The padding around the content.
    ///   - spacing: The spacing between UI elements.
    init(backgroundColor: Color, padding: EdgeInsets, spacing: CGFloat) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
    }
}

// MARK: - Themed Style Extension
extension DictionaryRemoteDetailsStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `DictionaryRemoteDetailsStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> DictionaryRemoteDetailsStyle {
        DictionaryRemoteDetailsStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            spacing: 16
        )
    }
}
