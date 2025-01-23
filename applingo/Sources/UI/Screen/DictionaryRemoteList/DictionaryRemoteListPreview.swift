import SwiftUI

#Preview("Remote Dictionaries Section") {
    NavigationView {
        DictionaryRemoteListViewList(
            locale: DictionaryRemoteListLocale(),
            dictionaryGetter: {
                let getter = DictionaryRemoteGetterViewModel()
                getter.dictionaries = [
                    DictionaryItemModel(
                        uuid: "en_basic",
                        name: "English Basic",
                        author: "John Doe",
                        category: "Language",
                        subcategory: "English",
                        description: "Basic English vocabulary",
                        id: 1
                    ),
                    DictionaryItemModel(
                        uuid: "es_basic",
                        name: "Spanish Basic",
                        author: "Maria Garcia",
                        category: "Language",
                        subcategory: "Spanish",
                        description: "Spanish vocabulary",
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
