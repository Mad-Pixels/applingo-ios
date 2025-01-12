import SwiftUI

struct DictionariesRemoteSection: View {
   @EnvironmentObject private var themeManager: ThemeManager
   @ObservedObject var dictionaryGetter: DictionaryRemoteGetterViewModel
   private let locale: ScreenDictionariesRemoteLocale
   let onDictionarySelect: (DictionaryItemModel) -> Void
   
   init(
       locale: ScreenDictionariesRemoteLocale,
       dictionaryGetter: DictionaryRemoteGetterViewModel,
       onDictionarySelect: @escaping (DictionaryItemModel) -> Void
   ) {
       self.locale = locale
       self.dictionaryGetter = dictionaryGetter
       self.onDictionarySelect = onDictionarySelect
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
           onItemTap: onDictionarySelect
       ) { dictionary in
           DictionaryRow(
               title: dictionary.displayName,
               subtitle: dictionary.subTitle,
               isActive: false,
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
