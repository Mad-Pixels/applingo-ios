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
                action: onSave
            )
            
            ButtonAction(
                title: locale.resetTitle,
                action: onReset
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
