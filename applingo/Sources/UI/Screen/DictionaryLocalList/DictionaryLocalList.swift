import SwiftUI

struct DictionaryLocalList: View {
    @StateObject private var style: DictionaryLocalListStyle
    @StateObject private var locale = DictionaryLocalListLocale()
    @StateObject private var dictionaryGetter = DictionaryGetter()

    @State private var selectedDictionary: DatabaseModelDictionary?
    @State private var isShowingInstructions = false
    @State private var isShowingRemoteList = false
   
    init(style: DictionaryLocalListStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
   
    var body: some View {
        BaseScreen(
            screen: .DictionaryLocalList,
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
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 130)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                DictionaryLocalListViewActions(
                    locale: locale,
                    onImport: { isShowingInstructions = true },
                    onDownload: { isShowingRemoteList = true }
                )
                .padding(.bottom, 80)
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
            DictionaryImport(
                isShowingFileImporter: $isShowingInstructions
            )
        }
        .fullScreenCover(isPresented: $isShowingRemoteList) {
            DictionaryRemoteList(isPresented: $isShowingRemoteList)
        }
    }
}
