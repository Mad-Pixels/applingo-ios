import SwiftUI

#Preview("Words Screen") {
    ScreenWords()
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocaleManager.shared)
}
