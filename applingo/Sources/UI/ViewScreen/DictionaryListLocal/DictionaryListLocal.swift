import SwiftUI

struct DictionaryListLocal: View {
   @StateObject private var style: DictionaryListLocalStyle
   @StateObject private var locale = DictionaryListLocalLocale()
   @StateObject private var dictionaryGetter = DictionaryLocalGetterViewModel()

   @State private var selectedDictionary: DictionaryItemModel?
   @State private var isShowingInstructions = false
   @State private var isShowingRemoteList = false
   
   init(style: DictionaryListLocalStyle? = nil) {
       let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
       _style = StateObject(wrappedValue: initialStyle)
   }
   
   var body: some View {
       BaseViewScreen(screen: .dictionariesLocal) {
           ZStack {
               VStack(spacing: style.spacing) {
                   DictionaryListLocalViewSearch(
                       searchText: $dictionaryGetter.searchText,
                       locale: locale
                   )
                   
                   DictionaryListLocalViewSection(
                       locale: locale,
                       dictionaryGetter: dictionaryGetter,
                       onDictionarySelect: { dictionary in
                           selectedDictionary = dictionary
                       }
                   )
               }
               .navigationTitle(locale.navigationTitle)
               .navigationBarTitleDisplayMode(.large)
               
               DictionaryListLocalViewActions(
                   locale: locale,
                   onImport: { isShowingInstructions = true },
                   onDownload: { isShowingRemoteList = true }
               )
           }
       }
       .sheet(item: $selectedDictionary) { dictionary in
           DictionaryLocalDetails(
               dictionary: dictionary,
               isPresented: .constant(true),
               refresh: {
                   dictionaryGetter.resetPagination()
               }
           )
           
       }
       .sheet(isPresented: $isShowingInstructions) {
           CompDictionaryInstructionView(
               isShowingFileImporter: $isShowingInstructions,
               onClose: {
                   isShowingInstructions = false
               }
           )
       }
       .fullScreenCover(isPresented: $isShowingRemoteList) {
           DictionaryListRemote(isPresented: $isShowingRemoteList)
       }
   }
}
