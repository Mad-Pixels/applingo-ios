import SwiftUI

#Preview("Word Detail Screen") {
    ScreenWordDetail(
        word: WordItemModel.empty(),
        isPresented: .constant(true),
        refresh: {}
    )
    .environmentObject(ThemeManager.shared)
}
