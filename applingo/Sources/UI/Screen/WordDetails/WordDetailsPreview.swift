import SwiftUI

#Preview("Word Detail Screen") {
    WordDetails(
        word: DatabaseModelWord.new(),
        isPresented: .constant(true),
        refresh: {}
    )
    .environmentObject(ThemeManager.shared)
    .environmentObject(LocaleManager.shared)
}
