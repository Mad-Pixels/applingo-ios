import SwiftUI

internal struct SettingsMainViewPermissionsMic: View {
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
        if !AppStorage.shared.useMicrophone {
            VStack(spacing: style.spacing) {
                SectionHeader(
                    title: locale.screenSubtitleMicrophonePermission,
                    style: .block(themeManager.currentThemeStyle)
                )
                .padding(.top, 8)

                SectionBody(content: {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenDescriptionMicrophonePermission),
                        style: .textLight(
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
