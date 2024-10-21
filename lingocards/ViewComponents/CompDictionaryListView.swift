import SwiftUI

struct CompDictionaryListView: View {
    let dictionaries: [DictionaryItem]
    let onDictionaryTap: (DictionaryItem) -> Void
    let onDelete: (IndexSet) -> Void
    let onToggle: (DictionaryItem, Bool) -> Void
    let theme: ThemeStyle

    var body: some View {
        List {
            ForEach(dictionaries, id: \.uiID) { dictionary in
                CompDictionaryRowView(
                    dictionary: dictionary,
                    onTap: {
                        onDictionaryTap(dictionary)
                    },
                    onToggle: { newStatus in
                        onToggle(dictionary, newStatus)
                    },
                    theme: theme
                )
                .padding(.vertical, 4)
            }
            .onDelete(perform: onDelete)
        }
    }
}
