import SwiftUI

struct WordListViewActions: View {
    let onAdd: () -> Void
    private let locale: WordListLocale
    
    init(
        locale: WordListLocale,
        onAdd: @escaping () -> Void
    ) {
        self.locale = locale
        self.onAdd = onAdd
    }
    
    var body: some View {
        ButtonFloatingSingle(
            icon: "plus.circle",
            action: onAdd
        )
    }
}
