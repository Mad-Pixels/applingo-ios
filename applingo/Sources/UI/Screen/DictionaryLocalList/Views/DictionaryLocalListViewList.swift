import SwiftUI

struct DictionaryLocalListViewList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var dictionaryGetter: DictionaryGetter
    @StateObject private var dictionaryAction = DictionaryAction()
    private let locale: DictionaryLocalListLocale
    let onDictionarySelect: (DatabaseModelDictionary) -> Void
   
    init(
        locale: DictionaryLocalListLocale,
        dictionaryGetter: DictionaryGetter,
        onDictionarySelect: @escaping (DatabaseModelDictionary) -> Void
    ) {
        self.locale = locale
        self.dictionaryGetter = dictionaryGetter
        self.onDictionarySelect = onDictionarySelect
    }
   
    var body: some View {
        ItemList<DatabaseModelDictionary, DictionaryLocalRow>(
            items: $dictionaryGetter.dictionaries,
            style: .themed(themeManager.currentThemeStyle),
            isLoadingPage: dictionaryGetter.isLoadingPage,
            error: nil,
            emptyListView: AnyView(Text(locale.emptyMessage)),
            onItemAppear: { dictionary in
                dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
            },
            onDelete: delete,
            onItemTap: onDictionarySelect
        ) { dictionary in
            DictionaryLocalRow(
                model: DictionaryLocalRowModel(
                    title: dictionary.name,
                    category: dictionary.category,
                    subcategory: dictionary.subcategory,
                    description: dictionary.description,
                    level: dictionary.level,
                    isActive: dictionary.isActive
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
        .onAppear {
            dictionaryAction.setFrame(.DictionaryLocalList)
            dictionaryGetter.setFrame(.DictionaryLocalList)
            dictionaryGetter.resetPagination()
        }
    }
   
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = dictionaryGetter.dictionaries[index]
            if dictionary.guid != "Internal" {
                dictionaryAction.delete(dictionary) { result in
                    if case .success = result {
                        dictionaryGetter.dictionaries.remove(at: index)
                    }
                }
            } else {
                struct InternalDictionaryError: LocalizedError {
                    var errorDescription: String? {
                        LocaleManager.shared.localizedString(for: "ErrDeleteInternalDictionary")
                        }
                    }
                    ErrorManager.shared.process(
                        InternalDictionaryError(),
                        screen: .DictionaryLocalList,
                        metadata: [:]
                    )
            }
        }
    }
   
    private func updateStatus(_ dictionary: DatabaseModelDictionary, newStatus: Bool) {
        guard let dictionaryID = dictionary.id else { return }
        dictionaryAction.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) { result in
            if case .success = result {
                dictionaryGetter.resetPagination()
            }
        }
    }
}
