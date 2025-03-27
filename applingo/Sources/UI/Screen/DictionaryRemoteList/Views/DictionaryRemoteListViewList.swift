import SwiftUI

/// A view that displays a list of remote dictionaries with pagination and selection support.
struct DictionaryRemoteListViewList: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle

    @ObservedObject private var dictionaryGetter: DictionaryFetcher
    let onDictionarySelect: (ApiModelDictionaryItem) -> Void
    
    // Флаг, чтобы предотвратить повторный вызов resetPagination
    @State private var initialLoadTriggered = false
    
    // MARK: - Initializer
    /// Initializes the list view with localization and a dictionary data source.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    ///   - dictionaryGetter: The data source for remote dictionaries.
    ///   - onDictionarySelect: Action closure when a dictionary is selected.
    init(
        locale: DictionaryRemoteListLocale,
        style: DictionaryRemoteListStyle,
        dictionaryGetter: DictionaryFetcher,
        onDictionarySelect: @escaping (ApiModelDictionaryItem) -> Void
    ) {
        self.locale = locale
        self.style = style
        self.dictionaryGetter = dictionaryGetter
        self.onDictionarySelect = onDictionarySelect
    }
    
    // MARK: - Body
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
            
            // Проверяем, был ли уже вызван resetPagination из родительского компонента
            if !initialLoadTriggered {
                // Используем небольшую задержку, чтобы родительский компонент успел вызвать resetPagination
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    // Проверяем, есть ли уже данные (если родительский компонент вызвал resetPagination)
                    if dictionaryGetter.dictionaries.isEmpty && !dictionaryGetter.isLoadingPage {
                        Logger.debug("[DictionaryRemoteList]: Initial load not triggered by parent, loading dictionaries")
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
                return AnyView(ItemListLoadingOverlay(style: .themed(themeManager.currentThemeStyle)))
            } else {
                return AnyView(DictionaryRemoteListViewNoItems(style: style, locale: locale))
            }
        } else {
            return AnyView(EmptyView())
        }
    }
}
