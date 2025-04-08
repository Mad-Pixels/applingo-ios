import SwiftUI

internal struct SettingsMainViewPermissionsASR: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var locale: SettingsMainLocale
    
    private let style: SettingsMainStyle
    
    /// Initializes the SettingsMainViewASRPermissions.
    /// - Parameters:
    ///   - style: `SettingsMainStyle` object that defines the visual style.
    ///   - locale: `SettingsMainLocale` object that provides localized strings.
    init(
        style: SettingsMainStyle,
        locale: SettingsMainLocale
    ) {
        self.locale = locale
        self.style = style
    }

    var body: some View {
        if !AppStorage.shared.useASR {
            VStack(spacing: style.spacing) {
                SectionHeader(
                    title: locale.screenSubtitleASRPermission,
                    style: .block(themeManager.currentThemeStyle)
                )
                .padding(.top, 8)

                
                DynamicText(
                    model: DynamicTextModel(text: locale.screenDescriptionASRPermission),
                    style: .textBold(
                        themeManager.currentThemeStyle,
                        alignment: .leading,
                        lineLimit: 8
                    )
                )
                .padding(.horizontal, 8)
                
                SectionBody(content: {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenSettingsASRPermission),
                        style: .textMain(
                            themeManager.currentThemeStyle,
                            alignment: .leading,
                            lineLimit: 8
                        )
                    )
                }, style: .accent(themeManager.currentThemeStyle))
                .padding(.horizontal, 8)
            }
        }
    }
}
