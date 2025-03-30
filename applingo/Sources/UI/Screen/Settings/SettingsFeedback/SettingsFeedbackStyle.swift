import SwiftUI

final class SettingsFeedbackStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color
    
    // Layout Properties
    let spacing: CGFloat
    let padding: EdgeInsets

    /// Initializes the SettingsFeedbackStyle.
    /// - Parameters:
    ///   - spacing: The spacing between elements.
    ///   - padding: The padding around the content.
    ///   - backgroundColor: The background color of the view.
    ///   - font: The font used for text elements.
    ///   - textColor: The color used for text elements.
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color
    ) {
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.padding = padding
    }
}

extension SettingsFeedbackStyle {
    static func themed(_ theme: AppTheme) -> SettingsFeedbackStyle {
        SettingsFeedbackStyle(
            spacing: 16,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
