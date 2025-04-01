import SwiftUI

internal struct GameModeViewSettings: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var noVoiceEnabled: Bool = AppStorage.shared.noVoice
    
    var body: some View {
        HStack {
            Text("Отключить озвучивание")
                .foregroundColor(themeManager.currentThemeStyle.textPrimary)
            
            Spacer()
            
            ItemCheckbox(
                isChecked: $noVoiceEnabled,
                onChange: { newValue in
                    AppStorage.shared.noVoice = newValue
                },
                style: .themed(themeManager.currentThemeStyle)
            )
        }
        .padding(.vertical, 8)
    }
}
