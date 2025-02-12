import SwiftUI

/// A view that displays a list of local dictionaries with search, import, and download functionalities.
struct DictionaryLocalList: View {
    // MARK: - Constants
    private let bottomInsetHeight: CGFloat = 130
    private let overlayBottomPadding: CGFloat = 80
    
    // MARK: - State Objects
    @StateObject private var style: DictionaryLocalListStyle
    @StateObject private var locale = DictionaryLocalListLocale()
    @StateObject private var dictionaryGetter = DictionaryGetter()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    // MARK: - Local State
    @State private var selectedDictionary: DatabaseModelDictionary?
    @State private var isShowingImportSheet = false
    @State private var isShowingRemoteList = false
   
    // MARK: - Initializer
    /// Initializes the local dictionary list view with an optional style.
    /// - Parameter style: Optional style configuration; if nil, a themed style is used.
    init(style: DictionaryLocalListStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(
            screen: .DictionaryLocalList,
            title: locale.screenTitle
        ) {
            VStack(spacing: 0) {
                DictionaryLocalListViewSearch(
                    style: style,
                    locale: locale,
                    searchText: $dictionaryGetter.searchText
                )
                .padding()
                
                DictionaryLocalListViewList(
                    style: style,
                    locale: locale,
                    dictionaryGetter: dictionaryGetter,
                    dictionaryAction: dictionaryAction,
                    onDictionarySelect: { dictionary in selectedDictionary = dictionary }
                )
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: bottomInsetHeight)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                DictionaryLocalListViewActions(
                    style: style,
                    locale: locale,
                    onImport: { isShowingImportSheet = true },
                    onDownload: { isShowingRemoteList = true }
                )
                .padding(.bottom, overlayBottomPadding)
            }
            .onAppear {
                dictionaryAction.setScreen(.DictionaryLocalList)
                dictionaryGetter.setScreen(.DictionaryLocalList)
                if dictionaryGetter.dictionaries.isEmpty {
                    dictionaryGetter.resetPagination()
                }
            }
            .onDisappear() {
                dictionaryGetter.clear()
            }
        }
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryLocalDetails(
                dictionary: dictionary,
                refresh: { dictionaryGetter.resetPagination() }
            )
        }
        .fullScreenCover(isPresented: $isShowingImportSheet) {
            DictionaryImport(isPresented: $isShowingImportSheet)
        }
        .fullScreenCover(isPresented: $isShowingRemoteList) {
            DictionaryRemoteList()
        }
    }
}
