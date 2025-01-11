import SwiftUI

struct DictionariesLocalSection: View {
   @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var dictionaryGetter: DictionaryLocalGetterViewModel
   @StateObject private var dictionaryAction = DictionaryLocalActionViewModel()
   private let locale: ScreenDictionariesLocalLocale
   
    init(
        locale: ScreenDictionariesLocalLocale,
        dictionaryGetter: DictionaryLocalGetterViewModel
    ) {
        self.locale = locale
        self.dictionaryGetter = dictionaryGetter
    }
   var body: some View {
       ItemsList<DictionaryItemModel, DictionaryRow>(
           items: $dictionaryGetter.dictionaries,
           style: .themed(themeManager.currentThemeStyle),
           isLoadingPage: dictionaryGetter.isLoadingPage,
           error: nil,
           emptyListView: AnyView(Text(locale.emptyMessage)),
           onItemAppear: { dictionary in
               dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
           },
           onDelete: delete,
           onItemTap: { _ in }
       ) { dictionary in
           DictionaryRow(
               title: dictionary.displayName,
               subtitle: dictionary.subTitle,
               isActive: dictionary.isActive,
               style: .themed(themeManager.currentThemeStyle),
               onTap: {
                   // TODO: Handle tap через callback от родителя
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
               let appError = AppErrorModel(
                   type: .ui,
                   message: LocaleManager.shared.localizedString(for: "ErrDeleteInternalDictionary"),
                   localized: LocaleManager.shared.localizedString(for: "ErrDeleteInternalDictionary"),
                   original: nil,
                   additional: nil
               )
               ErrorManager1.shared.setError(
                   appError: appError,
                   frame: .tabDictionaries,
                   source: .dictionaryDelete
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
