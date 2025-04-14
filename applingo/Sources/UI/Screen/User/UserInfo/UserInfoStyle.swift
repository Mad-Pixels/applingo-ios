import SwiftUI

final class UserInfoStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color
    let accentColor: Color

    init(
        backgroundColor: Color,
        accentColor: Color
    ) {
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
    }
}

extension UserInfoStyle {
    static func themed(_ theme: AppTheme) -> UserInfoStyle {
        UserInfoStyle(
            backgroundColor: theme.backgroundPrimary,
            accentColor: theme.accentPrimary
        )
    }
}
