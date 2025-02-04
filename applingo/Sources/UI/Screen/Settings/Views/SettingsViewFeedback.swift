import SwiftUI

/// A view that displays the feedback section in Settings.
struct SettingsViewFeedback: View {
    
    // MARK: - Environment
    
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var locale = SettingsLocale()
    
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
