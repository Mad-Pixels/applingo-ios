import SwiftUI

#Preview("Learn Screen") {
    Home()
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocaleManager.shared)
}
