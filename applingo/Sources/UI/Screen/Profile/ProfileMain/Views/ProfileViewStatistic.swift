import SwiftUI

internal struct ProfileViewStatistic: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: ProfileMainLocale
    private let style: ProfileMainStyle
    private let profile: ProfileModel
    
    /// Initializes the ProfileViewProgress.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    init(
        style: ProfileMainStyle,
        locale: ProfileMainLocale,
        profile: ProfileModel
    ) {
        self.profile = profile
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        SectionBody {
            VStack(alignment: .center, spacing: style.mainPadding) {
                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: "\(locale.screenTextNeedXp):"),
                        style: .textBold(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 1
                        )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                    
                    DynamicText(
                        model: DynamicTextModel(text: "\(profile.xpNext - profile.xpCurrent)"),
                        style: .textGame(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                    .frame(width: 60, alignment: .trailing)
                }
                
                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: "\(locale.screenTextAllXp):"),
                        style: .textBold(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 1
                        )
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)

                    DynamicText(
                        model: DynamicTextModel(text: "\(profile.xpTotal)"),
                        style: .textGame(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                    .frame(width: 60, alignment: .trailing)
                }
            }
            .padding(style.mainPadding)
        }
    }
}
