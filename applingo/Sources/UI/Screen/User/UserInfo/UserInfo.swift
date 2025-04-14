import SwiftUI

struct UserInfo: View {
    @StateObject private var style: UserInfoStyle
    @StateObject private var locale = UserInfoLocale()
    
    
    /// Initializes the UserInfo.
    /// - Parameter style: The style for the picker. Defaults to themed style using the current theme.
    init(
        style: UserInfoStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .UserInfo,
            title: locale.screenTitle
        ) {
            VStack(spacing: 0) {
                Text("Hello user")
            }
        }
    }
}
