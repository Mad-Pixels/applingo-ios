import SwiftUI

#Preview("Word Detail Screen") {
    WordDetails(
        word: DatabaseModelWord.empty(),
        isPresented: .constant(true),
        refresh: {}
    )
    .environmentObject(ThemeManager.shared)
    .environmentObject(LocaleManager.shared)
}
