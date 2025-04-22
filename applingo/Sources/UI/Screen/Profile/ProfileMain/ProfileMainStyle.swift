import SwiftUI

final class ProfileMainStyle: ObservableObject {
    // Color Properties
    let backgroundColor: Color
    let accentColor: Color
    let borderColor: Color
    
    // Size
    let avatarSize: CGFloat
    
    // Layout
    let blockPadding: CGFloat
    let mainPadding: CGFloat

    init(
        backgroundColor: Color,
        accentColor: Color,
        borderColor: Color,
        avatarSize: CGFloat,
        blockPadding: CGFloat,
        mainPadding: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.borderColor = borderColor
        self.avatarSize = avatarSize
        self.blockPadding = blockPadding
        self.mainPadding = mainPadding
    }
}

extension ProfileMainStyle {
    static func themed(_ theme: AppTheme) -> ProfileMainStyle {
        ProfileMainStyle(
            backgroundColor: theme.backgroundPrimary,
            accentColor: theme.accentPrimary,
            borderColor: theme.cardBorder,
            avatarSize: 128,
            blockPadding: 32,
            mainPadding: 16
        )
    }
}
