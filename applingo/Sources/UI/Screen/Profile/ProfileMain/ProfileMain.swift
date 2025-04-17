import SwiftUI

struct ProfileMain: View {
    @StateObject private var style: ProfileMainStyle
    @StateObject private var locale = ProfileMainLocale()
    
    private let profile = ProfileStorage().get()

    init(
        style: ProfileMainStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .Profile,
            title: locale.screenTitle
        ) {
            VStack(spacing: 20) {
                Text("Level: \(profile.level)")
                Text("XP: \(profile.xp)")
            }
        }
    }
}
