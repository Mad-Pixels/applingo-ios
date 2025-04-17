import SwiftUI

struct ProfileMain: View {
    @StateObject private var style: ProfileMainStyle
    @StateObject private var locale = ProfileMainLocale()
    
    @State private var profile: ProfileModel = ProfileStorage.shared.get()

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
                Text("XP: \(profile.xpCurrent)")
                Text("XP до следующего уровня: \(profile.xpNext)")
            }
        }
        .onAppear {
            profile = ProfileStorage.shared.get()
        }
    }
}
