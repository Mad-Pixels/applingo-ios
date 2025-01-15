import SwiftUI

struct DictionaryLocalList: View {
    @StateObject private var style: DictionaryLocalListStyle
    @StateObject private var locale = DictionaryLocalListLocale()
    @StateObject private var dictionaryGetter = DictionaryLocalGetterViewModel()

    @State private var selectedDictionary: DictionaryItemModel?
    @State private var isShowingInstructions = false
    @State private var isShowingRemoteList = false
   
    init(style: DictionaryLocalListStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
   
    var body: some View {
        BaseScreen(
            screen: .dictionariesLocal,
            title: locale.navigationTitle
        ) {
            VStack(spacing: 0) {
                DictionaryLocalListViewSearch(
                    searchText: $dictionaryGetter.searchText,
                    locale: locale
                )
                .padding()
                       
                DictionaryLocalListViewList(
                    locale: locale,
                    dictionaryGetter: dictionaryGetter,
                    onDictionarySelect: { dictionary in
                        selectedDictionary = dictionary
                    }
                )
            }
            .overlay(alignment: .bottomTrailing) {
                DictionaryLocalListViewActions(
                    locale: locale,
                    onImport: { isShowingInstructions = true },
                    onDownload: { isShowingRemoteList = true }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
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
            DictionaryRemoteList(isPresented: $isShowingRemoteList)
        }
    }
}
