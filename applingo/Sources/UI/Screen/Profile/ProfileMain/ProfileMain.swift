import SwiftUI

struct ProfileMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var localeManager: LocaleManager
    
    @ObservedObject private var locale = ProfileMainLocale()
    @StateObject private var style: ProfileMainStyle

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
