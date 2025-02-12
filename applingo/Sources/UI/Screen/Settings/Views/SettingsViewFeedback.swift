import SwiftUI

/// A view that displays the feedback section in Settings.
struct SettingsViewFeedback: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: SettingsLocale
    private let style: SettingsStyle
    
    // MARK: - Initializer
    /// Initializes the additional details view.
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
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(
                title: locale.screenSubtitleFeedback,
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            .padding(.bottom, -8)
            
            SectionBody {
                HStack {
                    NavigationLink(destination: SettingsFeedback()) {
                        Text(locale.screenDescriptionFeedback)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
