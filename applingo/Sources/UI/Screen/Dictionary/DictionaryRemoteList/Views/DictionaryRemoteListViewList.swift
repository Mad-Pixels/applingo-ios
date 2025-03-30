import SwiftUI

internal struct DictionaryRemoteListViewList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var dictionaryGetter: DictionaryFetcher
    
    @State private var initialLoadTriggered = false
    
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle

    internal let onDictionarySelect: (ApiModelDictionaryItem) -> Void

    /// Initializes the DictionaryRemoteListViewList.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    ///   - dictionaryGetter: The data source for remote dictionaries.
    ///   - onDictionarySelect: Action closure when a dictionary is selected.
    init(
        style: DictionaryRemoteListStyle,
        locale: DictionaryRemoteListLocale,
        dictionaryGetter: DictionaryFetcher,
        onDictionarySelect: @escaping (ApiModelDictionaryItem) -> Void
    ) {
        self.onDictionarySelect = onDictionarySelect
        self.dictionaryGetter = dictionaryGetter
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        let dictionariesBinding = Binding(
            get: { dictionaryGetter.dictionaries },
            set: { newValue in
                Logger.warning("[DictionaryRemoteList]: Attempt to modify read-only words binding")
            }
        )
        
        ItemList<ApiModelDictionaryItem, DictionaryRemoteRow>(
            items: dictionariesBinding,
            style: .themed(themeManager.currentThemeStyle),
            isLoadingPage: dictionaryGetter.isLoadingPage,
            error: nil,
            emptyListView: emptyStateView,
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
                    downloads: dictionary.downloads,
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
            
            if !initialLoadTriggered {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                    if dictionaryGetter.dictionaries.isEmpty && !dictionaryGetter.isLoadingPage {
                        dictionaryGetter.resetPagination(with: ApiModelDictionaryQueryRequest())
                    }
                    initialLoadTriggered = true
                }
            }
        }
    }
    
    /// A computed property that returns a view for the empty state.
    private var emptyStateView: AnyView {
        if dictionaryGetter.dictionaries.isEmpty {
            if dictionaryGetter.isLoadingPage || !dictionaryGetter.hasLoadedInitialPage {
                return AnyView(ItemListLoading(style: .themed(themeManager.currentThemeStyle)))
            } else {
                return AnyView(DictionaryRemoteListViewNoItems(style: style, locale: locale))
            }
        } else {
            return AnyView(EmptyView())
        }
    }
}
