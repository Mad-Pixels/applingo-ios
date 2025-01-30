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
        let dictionariesBinding = Binding(
            get: { dictionaryGetter.dictionaries },
            set: { _ in }
        )
        
        ItemList<DatabaseModelDictionary, DictionaryLocalRow>(
            items: dictionariesBinding,
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
            dictionaryAction.setScreen(.DictionaryLocalList)
            dictionaryGetter.setScreen(.DictionaryLocalList)
            dictionaryGetter.resetPagination()
        }
    }
   
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            guard index < dictionaryGetter.dictionaries.count else {
                Logger.warning("[DictionaryList]: Attempted to delete item at invalid index", metadata: [
                    "index": String(index),
                    "totalCount": String(dictionaryGetter.dictionaries.count)
                ])
                return
            }
            
            let dictionary = dictionaryGetter.dictionaries[index]
            
            if dictionary.guid == "Internal" {
                handleInternalDictionaryDeletion()
                return
            }
            
            deleteDictionary(dictionary, at: index)
        }
    }
    
    private func deleteDictionary(_ dictionary: DatabaseModelDictionary, at index: Int) {
        dictionaryAction.delete(dictionary) { result in
            if case .success = result {
                Logger.info("[DictionaryList]: Successfully deleted dictionary", metadata: [
                    "dictionaryId": dictionary.id.map(String.init) ?? "nil",
                    "name": dictionary.name
                ])
                dictionaryGetter.removeDictionary(at: index)
            } else {
                Logger.error("[DictionaryList]: Failed to delete dictionary", metadata: [
                    "dictionaryId": dictionary.id.map(String.init) ?? "nil",
                    "name": dictionary.name
                ])
            }
        }
    }
    
    private func handleInternalDictionaryDeletion() {
        struct InternalDictionaryError: LocalizedError {
            var errorDescription: String? {
                LocaleManager.shared.localizedString(for: "ErrDeleteInternalDictionary")
            }
        }
        
        Logger.warning("[DictionaryList]: Attempted to delete internal dictionary")
        
        ErrorManager.shared.process(
            InternalDictionaryError(),
            screen: .DictionaryLocalList,
            metadata: ["operation": "deleteDictionary", "type": "internal"]
        )
    }
   
    private func updateStatus(_ dictionary: DatabaseModelDictionary, newStatus: Bool) {
        guard let dictionaryID = dictionary.id else {
            Logger.error("[DictionaryList]: Cannot update status - dictionary ID is nil", metadata: [
                "dictionary": dictionary.name
            ])
            return
        }
        
        Logger.debug("[DictionaryList]: Updating dictionary status", metadata: [
            "dictionaryId": String(dictionaryID),
            "oldStatus": String(dictionary.isActive),
            "newStatus": String(newStatus)
        ])
        
        dictionaryAction.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) { result in
            if case .success = result {
                Logger.info("[DictionaryList]: Successfully updated dictionary status", metadata: [
                    "dictionaryId": String(dictionaryID),
                    "newStatus": String(newStatus)
                ])
                dictionaryGetter.resetPagination()
            } else {
                Logger.error("[DictionaryList]: Failed to update dictionary status", metadata: [
                    "dictionaryId": String(dictionaryID)
                ])
            }
        }
    }
}
