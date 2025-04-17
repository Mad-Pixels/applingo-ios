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
            VStack(alignment: .center) {
                DynamicText(
                    model: DynamicTextModel(text: locale.screenSubtitleLevel),
                    style: .headerMain(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 1
                    )
                )

                DynamicText(
                    model: DynamicTextModel(text: "\(profile.level)"),
                    style: .headerGame(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 1
                    )
                )
                
                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenSubtitleProgress),
                        style: .textGame(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 1
                        )
                    )

                    DynamicText(
                        model: DynamicTextModel(text: "\(profile.xpCurrent) / \(profile.xpNext)"),
                        style: .textBold(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                }

                ChartIndicator(
                    weight: min(1000, Int(Double(profile.xpCurrent) / Double(profile.xpNext) * 1000)),
                    style: .themed(themeManager.currentThemeStyle)
                )
                .frame(height: 12)

                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenTextNeedXp),
                        style: .textMain(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 1
                        )
                    )

                    DynamicText(
                        model: DynamicTextModel(text: "\(profile.xpNext - profile.xpCurrent)"),
                        style: .textBold(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                }

                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenTextCurrentXp),
                        style: .textMain(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 1
                        )
                    )

                    DynamicText(
                        model: DynamicTextModel(text: "\(profile.xpCurrent)"),
                        style: .textBold(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                }

                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenTextAllXp),
                        style: .textMain(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 1
                        )
                    )

                    DynamicText(
                        model: DynamicTextModel(text: "\(profile.xpTotal)"),
                        style: .textBold(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                }
            }
            .padding(8)
        }
    }
}
