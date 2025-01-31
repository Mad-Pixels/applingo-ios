import SwiftUI

/// A view that displays a list of remote dictionaries with pagination and selection support.
struct DictionaryRemoteListViewList: View {
    
    // MARK: - Environment and Observed Objects
    
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var dictionaryGetter: DictionaryFetcher
    
    // MARK: - Properties
    
    private let locale: DictionaryRemoteListLocale
    let onDictionarySelect: (ApiModelDictionaryItem) -> Void
    
    // MARK: - Initializer
    
    /// Initializes the list view with localization and a dictionary data source.
    /// - Parameters:
    ///   - locale: The localization object.
    ///   - dictionaryGetter: The data source for remote dictionaries.
    ///   - onDictionarySelect: Action closure when a dictionary is selected.
    init(
        locale: DictionaryRemoteListLocale,
        dictionaryGetter: DictionaryFetcher,
        onDictionarySelect: @escaping (ApiModelDictionaryItem) -> Void
    ) {
        self.locale = locale
        self.dictionaryGetter = dictionaryGetter
        self.onDictionarySelect = onDictionarySelect
    }
    
    // MARK: - Body
    
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
            dictionaryGetter.setScreen(.DictionaryRemoteList)
            dictionaryGetter.resetPagination(with: ApiModelDictionaryQueryRequest())
        }
    }
}
