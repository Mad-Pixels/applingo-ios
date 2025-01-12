import SwiftUI

#Preview("Settings Screen") {
    Settings()
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocaleManager.shared)
}
