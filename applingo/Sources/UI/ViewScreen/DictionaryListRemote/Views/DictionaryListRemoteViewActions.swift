import SwiftUI

struct DictionaryListRemoteViewActions: View {
    let onFilter: () -> Void
    private let locale: DictionaryListRemoteLocale
    
    init(
        locale: DictionaryListRemoteLocale,
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
