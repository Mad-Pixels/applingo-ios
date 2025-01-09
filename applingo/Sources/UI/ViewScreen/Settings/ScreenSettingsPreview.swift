import SwiftUI

#Preview("Settings Screen") {
    ScreenSettings()
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocaleManager.shared)
}
