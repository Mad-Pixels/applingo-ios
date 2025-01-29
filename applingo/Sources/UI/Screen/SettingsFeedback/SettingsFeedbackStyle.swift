import SwiftUI

final class SettingsFeedbackStyle: ObservableObject {
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    init(
        spacing: CGFloat,
        padding: EdgeInsets,
        backgroundColor: Color
    ) {
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
    }
}

extension SettingsFeedbackStyle {
    static func themed(_ theme: AppTheme) -> SettingsFeedbackStyle {
        SettingsFeedbackStyle(
            spacing: 24,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            backgroundColor: theme.backgroundPrimary
        )
    }
}
