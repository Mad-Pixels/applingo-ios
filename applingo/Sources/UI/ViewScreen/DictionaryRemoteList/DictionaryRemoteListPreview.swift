import SwiftUI

#Preview("Remote Dictionaries Section") {
    NavigationView {
        DictionaryRemoteListViewList(
            locale: DictionaryRemoteListLocale(),
            dictionaryGetter: {
                let getter = DictionaryRemoteGetterViewModel()
                getter.dictionaries = [
                    DictionaryItemModel(
                        id: 1,
                        key: "en_basic",
                        displayName: "English Basic",
                        tableName: "en_basic",
                        description: "Basic English vocabulary",
                        category: "Language",
                        subcategory: "English",
                        author: "John Doe"
                    ),
                    DictionaryItemModel(
                        id: 2,
                        key: "es_basic",
                        displayName: "Spanish Basic",
                        tableName: "es_basic",
                        description: "Spanish vocabulary",
                        category: "Language",
                        subcategory: "Spanish",
                        author: "Maria Garcia"
                    )
                ]
                return getter
            }(),
            onDictionarySelect: { _ in }
        )
    }
    .environmentObject(ThemeManager.shared)
}
