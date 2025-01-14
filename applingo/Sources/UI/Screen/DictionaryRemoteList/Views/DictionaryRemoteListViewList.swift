import SwiftUI

struct DictionaryRemoteListViewList: View {
   @EnvironmentObject private var themeManager: ThemeManager
   @ObservedObject var dictionaryGetter: DictionaryRemoteGetterViewModel
   private let locale: DictionaryRemoteListLocale
   let onDictionarySelect: (DictionaryItemModel) -> Void
   
   init(
       locale: DictionaryRemoteListLocale,
       dictionaryGetter: DictionaryRemoteGetterViewModel,
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
           onItemTap: onDictionarySelect
       ) { dictionary in
           DictionaryRow(
            model: DictionaryRowModel(
                title: dictionary.displayName,
                category: dictionary.category,
                subcategory: dictionary.subcategory,
                description: dictionary.description,
                wordsCount: 1234,
                isActive: dictionary.isActive
            ),

               style: .themed(themeManager.currentThemeStyle),
               onTap: {
                   onDictionarySelect(dictionary)
               },
               onToggle: { _ in }
           )
       }
       .onAppear {
           dictionaryGetter.setFrame(.dictionaryRemoteList)
           dictionaryGetter.resetPagination(with: ApiDictionaryQueryRequestModel())
       }
   }
}
