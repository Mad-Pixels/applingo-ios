import SwiftUI

struct DictionaryListLocalViewSection: View {
   @EnvironmentObject private var themeManager: ThemeManager
   @ObservedObject var dictionaryGetter: DictionaryLocalGetterViewModel
   @StateObject private var dictionaryAction = DictionaryLocalActionViewModel()
   private let locale: DictionaryListLocalLocale
   let onDictionarySelect: (DictionaryItemModel) -> Void
   
   init(
       locale: DictionaryListLocalLocale,
       dictionaryGetter: DictionaryLocalGetterViewModel,
       onDictionarySelect: @escaping (DictionaryItemModel) -> Void
   ) {
       self.locale = locale
       self.dictionaryGetter = dictionaryGetter
       self.onDictionarySelect = onDictionarySelect
   }
   
   var body: some View {
       ItemList<DictionaryItemModel, DictionaryRow>(
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
           DictionaryRow(
               title: dictionary.displayName,
               subtitle: dictionary.subTitle,
               isActive: dictionary.isActive,
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
           dictionaryAction.setFrame(.tabDictionaries)
           dictionaryGetter.setFrame(.tabDictionaries)
           dictionaryGetter.resetPagination()
       }
   }
   
   private func delete(at offsets: IndexSet) {
       offsets.forEach { index in
           let dictionary = dictionaryGetter.dictionaries[index]
           if dictionary.tableName != "Internal" {
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
                   screen: .dictionariesLocal
               )
           }
       }
   }
   
   private func updateStatus(_ dictionary: DictionaryItemModel, newStatus: Bool) {
       guard let dictionaryID = dictionary.id else { return }
       dictionaryAction.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) { result in
           if case .success = result {
               dictionaryGetter.resetPagination()
           }
       }
   }
}
