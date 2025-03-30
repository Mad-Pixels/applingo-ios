import SwiftUI

internal struct SettingsMainViewFeedback: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var locale: SettingsMainLocale
    
    private let style: SettingsMainStyle
    
    /// Initializes the SettingsMainViewFeedback.
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
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleFeedback,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                SectionBody {
                    HStack {
                        NavigationLink(destination: SettingsFeedback()) {
                            DynamicText(
                                model: DynamicTextModel(text: locale.screenDescriptionFeedback),
                                style: .textMain(themeManager.currentThemeStyle)
                            )
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(style.navIconColor)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
