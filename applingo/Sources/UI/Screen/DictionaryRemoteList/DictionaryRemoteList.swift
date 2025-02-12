import SwiftUI

/// A view that displays a list of remote dictionaries with search, filter, and selection functionalities.
struct DictionaryRemoteList: View {
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - State Objects
    @StateObject private var style: DictionaryRemoteListStyle
    @StateObject private var locale = DictionaryRemoteListLocale()
    @StateObject private var dictionaryGetter = DictionaryFetcher()
    
    // MARK: - Local State
    @State private var apiRequestParams = ApiModelDictionaryQueryRequest()
    @State private var selectedDictionary: ApiModelDictionaryItem?
    @State private var isShowingFilterView = false
    @State private var isPressedTrailing = false
    
    // MARK: - Initializer
    /// Initializes the DictionaryRemoteList view.
    /// - Parameter style: Optional style; if nil, a themed style is used.
    init(style: DictionaryRemoteListStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
    }
    
    // MARK: - Body
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
                    locale: locale,
                    style: style,
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .close(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            AppStorage.shared.activeScreen = .DictionaryLocalList
                            NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
                            presentationMode.wrappedValue.dismiss()
                        },
                        isPressed: $isPressedTrailing
                    )
                }
            }
        }
        .sheet(isPresented: $isShowingFilterView) {
            DictionaryRemoteFilter(apiRequestParams: $apiRequestParams)
                .environmentObject(ThemeManager.shared)
                .environmentObject(LocaleManager.shared)
        }
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryRemoteDetails(dictionary: dictionary)
                .environmentObject(ThemeManager.shared)
                .environmentObject(LocaleManager.shared)
        }
        .onAppear {
            dictionaryGetter.resetPagination(with: apiRequestParams)
        }
        .onChange(of: apiRequestParams) { newParams in
            dictionaryGetter.resetPagination(with: newParams)
        }
    }
}
