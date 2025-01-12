import SwiftUI

struct DictionaryRemoteFilterViewActions: View {
    let onSave: () -> Void
    let onReset: () -> Void
    private let locale: DictionaryRemoteFilterLocale
    
    init(
            locale: DictionaryRemoteFilterLocale,
            onSave: @escaping () -> Void,
            onReset: @escaping () -> Void
        ) {
            self.locale = locale
            self.onSave = onSave
            self.onReset = onReset
        }
    
    var body: some View {
        HStack {
            ButtonAction(
                title: locale.saveTitle,
                type: .action,
                action: onSave
            )
            
            ButtonAction(
                title: locale.resetTitle,
                type: .cancel,
                action: onReset
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
