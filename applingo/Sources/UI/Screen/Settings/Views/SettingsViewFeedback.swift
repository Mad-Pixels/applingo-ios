import SwiftUI

/// A view that displays the feedback section in Settings.
struct SettingsViewFeedback: View {
    
    // MARK: - Environment
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(
                title: "Feedback",  // Здесь можно заменить на локализованное значение, если требуется.
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, 8)
            .padding(.bottom, -8)
            
            SectionBody {
                HStack {
                    NavigationLink(destination: SettingsFeedback()) {
                        Text("Send Feedback")  // Замените на локализованный текст по необходимости.
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
