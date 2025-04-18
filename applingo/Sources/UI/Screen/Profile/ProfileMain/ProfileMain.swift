import SwiftUI

struct ProfileMain: View {
    @StateObject private var style: ProfileMainStyle
    @StateObject private var locale = ProfileMainLocale()
    @EnvironmentObject private var themeManager: ThemeManager
    
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
            VStack(spacing: style.blockPadding) {
                ProfileViewProgress(
                    style: style,
                    locale: locale,
                    profile: profile
                )
                
                ProfileViewStatistic(
                    style: style,
                    locale: locale,
                    profile: profile
                )
            }
            .padding(.horizontal, style.mainPadding)
            .padding(.top, style.mainPadding)
        }
        .onAppear {
            profile = ProfileStorage.shared.get()
        }
    }
}
