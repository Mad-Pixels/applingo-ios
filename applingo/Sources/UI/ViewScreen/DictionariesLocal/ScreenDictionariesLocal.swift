import SwiftUI

struct ScreenDictionariesLocal: View {
   @StateObject private var style: ScreenDictionariesLocalStyle
   @StateObject private var locale = ScreenDictionariesLocalLocale()
   @StateObject private var dictionaryGetter = DictionaryLocalGetterViewModel()

   @State private var selectedDictionary: DictionaryItemModel?
   @State private var isShowingInstructions = false
   @State private var isShowingRemoteList = false
   
   init(style: ScreenDictionariesLocalStyle? = nil) {
       let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
       _style = StateObject(wrappedValue: initialStyle)
   }
   
   var body: some View {
       BaseViewScreen(screen: .dictionariesLocal) {
           ZStack {
               VStack(spacing: style.spacing) {
                   DictionariesLocalSearch(
                       searchText: $dictionaryGetter.searchText,
                       locale: locale
                   )
                   
                   DictionariesLocalSection(
                       locale: locale,
                       dictionaryGetter: dictionaryGetter,
                       onDictionarySelect: { dictionary in
                           selectedDictionary = dictionary
                       }
                   )
               }
               .navigationTitle(locale.navigationTitle)
               .navigationBarTitleDisplayMode(.large)
               
               DictionaryLocalActions(
                   locale: locale,
                   onImport: { isShowingInstructions = true },
                   onDownload: { isShowingRemoteList = true }
               )
           }
       }
       .sheet(item: $selectedDictionary) { dictionary in
           ScreenDictionaryLocalDetail(
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
           ScreenDictionariesRemote(isPresented: $isShowingRemoteList)
       }
   }
}
