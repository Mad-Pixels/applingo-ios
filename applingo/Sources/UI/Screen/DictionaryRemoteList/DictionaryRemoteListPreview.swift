import SwiftUI

#Preview("Remote Dictionaries Section") {
    NavigationView {
        DictionaryRemoteListViewList(
            locale: DictionaryRemoteListLocale(),
            dictionaryGetter: {
                let getter = DictionaryFetcher()
                getter.dictionaries = [
                    DatabaseModelDictionary(
                        guid: "en_basic",
                        name: "English Basic",
                        author: "John Doe",
                        category: "Language",
                        subcategory: "English",
                        description: "Basic English vocabulary",
                        id: 1
                    ),
                    DatabaseModelDictionary(
                        guid: "es_basic",
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
