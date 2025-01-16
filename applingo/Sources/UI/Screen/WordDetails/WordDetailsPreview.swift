import SwiftUI

#Preview("Word Detail Screen") {
    WordDetails(
        word: WordItemModel.empty(),
        isPresented: .constant(true),
        refresh: {}
    )
    .environmentObject(ThemeManager.shared)
    .environmentObject(LocaleManager.shared)
}
