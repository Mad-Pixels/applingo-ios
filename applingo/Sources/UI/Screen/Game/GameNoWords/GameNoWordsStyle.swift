import SwiftUI

/// Defines styling properties for the GameNoWords view.
final class GameNoWordsStyle: ObservableObject {
    // Layout
    let padding: EdgeInsets
    let spacing: CGFloat

    /// Initializes the GameNoWordsStyle.
    /// - Parameters:
    ///   - padding: The overall padding around the content.
    ///   - spacing: The spacing between individual elements.
    init(
        padding: EdgeInsets,
        spacing: CGFloat
    ) {
        self.padding = padding
        self.spacing = spacing
    }
}

extension GameNoWordsStyle {
    static func themed(_ theme: AppTheme) -> GameNoWordsStyle {
        GameNoWordsStyle(
            padding: EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16),
            spacing: 24
        )
    }
}
