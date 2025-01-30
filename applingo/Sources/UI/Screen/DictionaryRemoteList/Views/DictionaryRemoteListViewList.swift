import SwiftUI

struct DictionaryRemoteListViewList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var dictionaryGetter: DictionaryFetcher
    private let locale: DictionaryRemoteListLocale
    let onDictionarySelect: (ApiModelDictionaryItem) -> Void
   
    init(
        locale: DictionaryRemoteListLocale,
        dictionaryGetter: DictionaryFetcher,
        onDictionarySelect: @escaping (ApiModelDictionaryItem) -> Void
    ) {
        self.locale = locale
        self.dictionaryGetter = dictionaryGetter
        self.onDictionarySelect = onDictionarySelect
    }
   
    var body: some View {
        let dictionariesBinding = Binding(
            get: { dictionaryGetter.dictionaries },
            set: { _ in }
        )
        
        ItemList<ApiModelDictionaryItem, DictionaryRemoteRow>(
            items: dictionariesBinding,
            style: .themed(themeManager.currentThemeStyle),
            isLoadingPage: dictionaryGetter.isLoadingPage,
            error: nil,
            emptyListView: AnyView(Text(locale.emptyMessage)),
            onItemAppear: { dictionary in
                dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
            },
            onItemTap: onDictionarySelect
        ) { dictionary in
            DictionaryRemoteRow(
                model: DictionaryRemoteRowModel(
                    subcategory: dictionary.subcategory,
                    description: dictionary.description,
                    category: dictionary.category,
                    title: dictionary.name,
                    level: dictionary.level,
                    topic: dictionary.topic,
                    rating: dictionary.rating,
                    words: dictionary.words
                ),
                style: .themed(themeManager.currentThemeStyle),
                dictionary: dictionary,
                onTap: {
                    onDictionarySelect(dictionary)
                },
                onToggle: { _ in }
            )
        }
        .onAppear {
            dictionaryGetter.setFrame(.DictionaryRemoteList)
            dictionaryGetter.resetPagination(with: ApiModelDictionaryQueryRequest())
        }
    }
}
