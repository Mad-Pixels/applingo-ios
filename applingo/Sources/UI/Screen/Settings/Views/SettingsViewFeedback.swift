import SwiftUI

struct SettingsViewFeedback: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        SectionHeader(
            title: "asd",
            style: .titled(themeManager.currentThemeStyle)
        )
        .padding(.top, 8)
        .padding(.bottom, -8)
        
        SectionBody{
            HStack() {
                NavigationLink(destination: SettingsFeedback()) {
                    Text("asd")
                }
            }
            .padding(.vertical, 8)
        }
    }
}
