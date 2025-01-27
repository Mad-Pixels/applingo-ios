import SwiftUI

struct DictionaryRemoteListViewList: View {
   @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var dictionaryGetter: DictionaryFetcher
   private let locale: DictionaryRemoteListLocale
   let onDictionarySelect: (DatabaseModelDictionary) -> Void
   
   init(
       locale: DictionaryRemoteListLocale,
       dictionaryGetter: DictionaryFetcher,
       onDictionarySelect: @escaping (DatabaseModelDictionary) -> Void
   ) {
       self.locale = locale
       self.dictionaryGetter = dictionaryGetter
       self.onDictionarySelect = onDictionarySelect
   }
   
   var body: some View {
       ItemList<DatabaseModelDictionary, DictionaryRemoteRow>(
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
           DictionaryRemoteRow(
            model: DictionaryRemoteRowModel(
                title: dictionary.name,
                category: dictionary.category,
                subcategory: dictionary.subcategory,
                description: dictionary.description,
                wordsCount: 1234
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
           //dictionaryGetter.setFrame(.dictionaryRemoteList)
           dictionaryGetter.resetPagination(with: ApiDictionaryQueryRequestModel())
       }
   }
}
