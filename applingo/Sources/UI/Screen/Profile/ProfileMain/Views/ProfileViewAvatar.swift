import SwiftUI

internal struct ProfileViewAvatar: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: ProfileMainLocale
    private let style: ProfileMainStyle
    private let level: Int64
    
    private let imageLevels = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    
    private var avatarImageName: String {
        let matchedLevel = imageLevels
            .filter { level >= $0 }
            .max() ?? 1
        return "profile_lvl_\(matchedLevel)"
    }
    
    /// Initializes the ProfileViewAvatar.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    ///   - level: The current user level.
    init(
        style: ProfileMainStyle,
        locale: ProfileMainLocale,
        level: Int64
    ) {
        self.locale = locale
        self.style = style
        self.level = level
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Circle()
                .fill(style.backgroundColor)
                .frame(width: style.avatarSize, height: style.avatarSize)
                .overlay(
                    Image(avatarImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: style.avatarSize, height: style.avatarSize)
                        .clipShape(Circle())
                )
                .overlay(
                    Circle()
                        .stroke(style.borderColor, lineWidth: 5)
                )
        }
    }
}
