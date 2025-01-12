import SwiftUI

struct DictionaryFilterActions: View {
    let onSave: () -> Void
    let onReset: () -> Void
    private let locale: ScreenDictionaryFilterLocale
    
    init(
            locale: ScreenDictionaryFilterLocale,
            onSave: @escaping () -> Void,
            onReset: @escaping () -> Void
        ) {
            self.locale = locale
            self.onSave = onSave
            self.onReset = onReset
        }
    
    var body: some View {
        HStack {
            ActionButton(
                title: locale.saveTitle,
                type: .action,
                action: onSave
            )
            
            ActionButton(
                title: locale.resetTitle,
                type: .cancel,
                action: onReset
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
