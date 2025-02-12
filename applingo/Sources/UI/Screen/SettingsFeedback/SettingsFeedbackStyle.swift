import SwiftUI

/// Defines styling properties for the SettingsFeedback view.
final class SettingsFeedbackStyle: ObservableObject {
    // MARK: - Properties
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    let font: Font
    let textColor: Color

    // MARK: - Initializer
    /// Initializes a new instance of `SettingsFeedbackStyle`.
    /// - Parameters:
    ///   - spacing: The spacing between elements.
    ///   - padding: The padding around the content.
    ///   - backgroundColor: The background color.
    ///   - font: The font used for the text.
    ///   - textColor: The color of the text.
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color,
        font: Font,
        textColor: Color
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.font = font
        self.textColor = textColor
    }
}

// MARK: - Themed Style Extension
extension SettingsFeedbackStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `SettingsFeedbackStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> SettingsFeedbackStyle {
        SettingsFeedbackStyle(
            spacing: 24,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary,
            font: .system(size: 13),
            textColor: theme.textSecondary
        )
    }
}
