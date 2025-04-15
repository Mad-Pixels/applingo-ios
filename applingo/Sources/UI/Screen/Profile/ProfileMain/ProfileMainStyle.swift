import SwiftUI

final class ProfileMainStyle: ObservableObject {
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

extension ProfileMainStyle {
    static func themed(_ theme: AppTheme) -> ProfileMainStyle {
        ProfileMainStyle(
            backgroundColor: theme.backgroundPrimary,
            accentColor: theme.accentPrimary
        )
    }
}
