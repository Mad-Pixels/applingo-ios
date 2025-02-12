import SwiftUI

/// Defines styling properties for the Dictionary Remote Filter view.
/// This class manages UI properties such as background color, spacing,
/// and padding to maintain consistent styling across themes.
final class DictionaryRemoteFilterStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let spacing: CGFloat
    let padding: EdgeInsets
    
    // MARK: - Initializer
    /// Initializes a new instance of `DictionaryRemoteFilterStyle`.
    /// - Parameters:
    ///   - backgroundColor: The background color for the filter view.
    ///   - spacing: The spacing between UI elements.
    ///   - padding: The padding applied to the filter view.
    init(
        backgroundColor: Color,
        spacing: CGFloat,
        padding: EdgeInsets
    ) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
    }
}

// MARK: - Themed Style Extension
extension DictionaryRemoteFilterStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `DictionaryRemoteFilterStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> DictionaryRemoteFilterStyle {
        DictionaryRemoteFilterStyle(
            backgroundColor: theme.backgroundPrimary,
            spacing: 16,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        )
    }
}
