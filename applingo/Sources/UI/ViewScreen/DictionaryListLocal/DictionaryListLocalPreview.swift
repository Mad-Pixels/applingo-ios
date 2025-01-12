import SwiftUI

#Preview("Dictionaries Local Screen") {
    DictionaryListLocal()
       .environmentObject(ThemeManager.shared)
       .environmentObject(LocaleManager.shared)
}
