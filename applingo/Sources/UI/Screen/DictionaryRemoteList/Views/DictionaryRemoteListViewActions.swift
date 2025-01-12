import SwiftUI

struct DictionaryRemoteListViewActions: View {
    let onFilter: () -> Void
    private let locale: DictionaryRemoteListLocale
    
    init(
        locale: DictionaryRemoteListLocale,
        onFilter: @escaping () -> Void
    ) {
        self.locale = locale
        self.onFilter = onFilter
    }
    
    var body: some View {
        ButtonFloatingSingle(
            icon: "line.horizontal.3.decrease.circle",
            action: onFilter
        )
    }
}
