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
                        description: "Basic English vocabulary",
                        category: "Language",
                        subcategory: "English",
                        author: "John Doe",
                        id: 1
                    ),
                    DictionaryItemModel(
                        uuid: "es_basic",
                        name: "Spanish Basic",
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
