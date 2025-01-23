import SwiftUI

#Preview("Remote Dictionaries Section") {
    NavigationView {
        DictionaryRemoteListViewList(
            locale: DictionaryRemoteListLocale(),
            dictionaryGetter: {
                let getter = DictionaryRemoteGetterViewModel()
                getter.dictionaries = [
                    DictionaryItemModel(
                        key: "en_basic",
                        displayName: "English Basic",
                        tableName: "en_basic",
                        description: "Basic English vocabulary",
                        category: "Language",
                        subcategory: "English",
                        author: "John Doe",
                        id: 1
                    ),
                    DictionaryItemModel(
                        key: "es_basic",
                        displayName: "Spanish Basic",
                        tableName: "es_basic",
                        description: "Spanish vocabulary",
                        category: "Language",
                        subcategory: "Spanish",
                        author: "Maria Garcia",
                        id: 2
                    )
                ]
                return getter
            }(),
            onDictionarySelect: { _ in }
        )
    }
    .environmentObject(ThemeManager.shared)
}
