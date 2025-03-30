import SwiftUI

/// A view that displays a list of remote dictionaries with search, filter, and selection functionalities.
struct DictionaryRemoteList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var style: DictionaryRemoteListStyle
    @StateObject private var locale = DictionaryRemoteListLocale()
    @StateObject private var dictionaryGetter = DictionaryFetcher()
    
    @State private var apiRequestParams = ApiModelDictionaryQueryRequest()
    @State private var selectedDictionary: ApiModelDictionaryItem?
    @State private var isShowingFilterView = false
    @State private var isPressedTrailing = false
    
    /// Initializes the DictionaryRemoteList.
    /// - Parameter style: Optional style; if nil, a themed style is used.
    init(style: DictionaryRemoteListStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryRemoteList,
            title: locale.screenTitle
        ) {
            VStack(spacing: style.spacing) {
                DictionaryRemoteListViewSearch(
                    style: style,
                    locale: locale,
                    searchText: $dictionaryGetter.searchText
                )
                .padding(style.padding)
                
                DictionaryRemoteListViewList(
                    style: style,
                    locale: locale,
                    dictionaryGetter: dictionaryGetter,
                    onDictionarySelect: { dictionary in
                        selectedDictionary = dictionary
                    }
                )
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 120)
                }
            }
            .background(style.backgroundColor)
            .overlay(alignment: .bottomTrailing) {
                DictionaryRemoteListViewActions(
                    style: style,
                    locale: locale,
                    onFilter: { isShowingFilterView = true }
                )
                .padding(.bottom, 42)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        isPressed: $isPressedTrailing,
                        onTap: {
                            AppStorage.shared.activeScreen = .DictionaryLocalList
                            NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
                            presentationMode.wrappedValue.dismiss()
                        },
                        style: .close(themeManager.currentThemeStyle)
                    )
                }
            }
        }
        .sheet(isPresented: $isShowingFilterView) {
            DictionaryRemoteFilter(apiRequestParams: $apiRequestParams)
        }
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryRemoteDetails(dictionary: dictionary)
        }
        .onAppear {
            dictionaryGetter.setScreen(.DictionaryRemoteList)
            dictionaryGetter.resetPagination(with: apiRequestParams)
        }
        .onDisappear{
            dictionaryGetter.searchText = ""
        }
        .onChange(of: apiRequestParams) { newParams in
            dictionaryGetter.resetPagination(with: newParams)
        }
    }
}
