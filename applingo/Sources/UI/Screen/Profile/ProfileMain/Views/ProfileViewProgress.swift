import SwiftUI

internal struct ProfileViewProgress: View {
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
            VStack(alignment: .center, spacing: style.blockPadding) {
                HStack {
                    ProfileViewAvatar(
                        style: style,
                        locale: locale,
                        level: profile.level
                    )
                    
                    Spacer()
                    
                    VStack {
                        DynamicText(
                            model: DynamicTextModel(text: locale.screenSubtitleLevel),
                            style: .headerMain(
                                ThemeManager.shared.currentThemeStyle,
                                alignment: .trailing,
                                lineLimit: 1
                            )
                        )
                        
                        DynamicText(
                            model: DynamicTextModel(text: "\(profile.level)"),
                            style: .headerHuge(
                                ThemeManager.shared.currentThemeStyle,
                                alignment: .trailing,
                                lineLimit: 1,
                                fontColor: style.accentColor
                            )
                        )
                    }
                }
                
                VStack(spacing: style.mainPadding) {
                    HStack {
                        DynamicText(
                            model: DynamicTextModel(text: "\(locale.screenSubtitleProgress):"),
                            style: .textGameBold(
                                ThemeManager.shared.currentThemeStyle,
                                alignment: .leading,
                                lineLimit: 1
                            )
                        )
                        
                        DynamicText(
                            model: DynamicTextModel(text: "\(profile.xpCurrent) / \(profile.xpNext)"),
                            style: .textGameBold(
                                ThemeManager.shared.currentThemeStyle,
                                alignment: .trailing,
                                lineLimit: 1,
                                fontColor: style.accentColor
                            )
                        )
                    }
                    
                    ChartIndicator(
                        weight: min(1000, Int(Double(profile.xpCurrent) / Double(profile.xpNext) * 1000)),
                        style: .md(themeManager.currentThemeStyle)
                    )
                }
            }
            .padding(style.mainPadding)
        }
    }
}
