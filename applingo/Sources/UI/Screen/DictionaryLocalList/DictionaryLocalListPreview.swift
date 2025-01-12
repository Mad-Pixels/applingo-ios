import SwiftUI

#Preview("Dictionaries Local Screen") {
    DictionaryLocalList()
       .environmentObject(ThemeManager.shared)
       .environmentObject(LocaleManager.shared)
}
