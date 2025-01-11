import SwiftUI

struct WordsActions: View {
    let onAdd: () -> Void
    private let locale: ScreenWordsLocale
    
    init(
        locale: ScreenWordsLocale,
        onAdd: @escaping () -> Void
    ) {
        self.locale = locale
        self.onAdd = onAdd
    }
    
    var body: some View {
        FloatingButtonMultiple(
            items: [
                IconAction(
                    icon: "plus.circle",
                    action: onAdd
                )
            ]
        )
    }
}
