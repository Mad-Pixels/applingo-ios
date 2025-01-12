import SwiftUI

#Preview("Words Screen") {
    WordList()
        .environmentObject(ThemeManager.shared)
        .environmentObject(LocaleManager.shared)
}
