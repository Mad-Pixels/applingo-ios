import SwiftUI

internal struct SettingsViewFeedback: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var locale: SettingsLocale
    
    private let style: SettingsStyle
    
    /// Initializes the SettingsViewFeedback.
    /// - Parameters:
    ///   - style: `SettingsStyle` object that defines the visual style.
    ///   - locale: `SettingsLocale` object that provides localized strings.
    init(
        style: SettingsStyle,
        locale: SettingsLocale
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
