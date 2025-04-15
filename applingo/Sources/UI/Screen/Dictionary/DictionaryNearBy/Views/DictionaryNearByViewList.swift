import SwiftUI

internal struct DictionaryNearByViewList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject private var dictionaryAction: DictionaryAction
    @ObservedObject private var dictionaryGetter: DictionaryGetter
    
    private let locale: DictionarySendLocale
    private let style: DictionarySendStyle
    
    internal let onDictionarySelect: (DatabaseModelDictionary) -> Void
    
    /// Initializes the DictionaryLocalListViewList.
    /// - Parameters:
    ///   - style: `DictionarySendStyle` object that defines the visual style.
    ///   - locale: `DictionarySendLocale` object that provides localized strings.
    ///   - dictionaryGetter: `DictionaryGetter` object responsible for fetching dictionaries..
    ///   - dictionaryAction: `DictionaryAction` object responsible for dictionaries actions.
    ///   - onDictionarySelect: Action when a dictionary is selected.
    init(
        style: DictionarySendStyle,
        locale: DictionarySendLocale,
        dictionaryGetter: DictionaryGetter,
        dictionaryAction: DictionaryAction,
        onDictionarySelect: @escaping (DatabaseModelDictionary) -> Void
    ) {
        self.locale = locale
        self.style = style
        self.dictionaryGetter = dictionaryGetter
        self.dictionaryAction = dictionaryAction
        self.onDictionarySelect = onDictionarySelect
    }
    
    var body: some View {
        let dictionariesBinding = Binding(
            get: { dictionaryGetter.dictionaries },
            set: { newValue in
                Logger.warning("[DictionaryLocalListViewList]: Attempt to modify read-only words binding")
            }
        )
        
        ItemList<DatabaseModelDictionary, DictionaryLocalRow>(
            items: dictionariesBinding,
            style: .themed(themeManager.currentThemeStyle),
            isLoadingPage: dictionaryGetter.isLoadingPage,
            error: nil,
            emptyListView: emptyStateView,
            onItemAppear: { dictionary in
                dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
            },
            onDelete: delete,
            onItemTap: onDictionarySelect,
            canDelete: { dictionary in
                dictionary.id != 1
            }
        ) { dictionary in
            DictionaryLocalRow(
                model: DictionaryLocalRowModel(
                    title: dictionary.name,
                    category: dictionary.category,
                    subcategory: dictionary.subcategory,
                    description: dictionary.description,
                    level: dictionary.level,
                    isActive: dictionary.isActive,
                    words: dictionary.count
                ),
                style: .themed(themeManager.currentThemeStyle),
                onTap: {
                    onDictionarySelect(dictionary)
                },
                onToggle: { newStatus in
                    updateStatus(dictionary, newStatus: newStatus)
                }
            )
        }
    }
    
    /// Deletes a dictionary at specified offsets.
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = dictionaryGetter.dictionaries[index]
            dictionaryAction.delete(dictionary) { result in
                if case .success = result {
                    DispatchQueue.main.async {
                        let getter = self.dictionaryGetter
                        getter.removeDictionary(at: index)
                    }
                }
            }
        }
    }
    
    /// Updates the active status of a dictionary.
    private func updateStatus(_ dictionary: DatabaseModelDictionary, newStatus: Bool) {
        guard let dictionaryID = dictionary.id else {
            return
        }
        
        dictionaryAction.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) { result in
            if case .success = result {
                DispatchQueue.main.async {
                    self.dictionaryGetter.updateDictionaryStatus(dictionaryID: dictionaryID, newStatus: newStatus)
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
                return  AnyView(EmptyView())
            }
        } else {
            return AnyView(EmptyView())
        }
    }
}
