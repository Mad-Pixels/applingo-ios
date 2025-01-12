import SwiftUI

struct DictionariesRemoteActions: View {
    let onFilter: () -> Void
    private let locale: ScreenDictionariesRemoteLocale
    
    init(
        locale: ScreenDictionariesRemoteLocale,
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
