import SwiftUI

/// A view that displays a list of local dictionaries with search, import, and download functionalities.
struct DictionaryLocalList: View {
    
    // MARK: - State Objects
    
    @StateObject private var style: DictionaryLocalListStyle
    @StateObject private var locale = DictionaryLocalListLocale()
    @StateObject private var dictionaryGetter = DictionaryGetter()
    
    // MARK: - Local State
    
    @State private var selectedDictionary: DatabaseModelDictionary?
    @State private var isShowingImportSheet = false
    @State private var isShowingRemoteList = false
   
    // MARK: - Initializer
    
    /// Initializes the local dictionary list view with an optional style.
    /// - Parameter style: Optional style configuration; if nil, a themed style is used.
    init(style: DictionaryLocalListStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(screen: .DictionaryLocalList, title: locale.screenTitle) {
            VStack(spacing: 0) {
                DictionaryLocalListViewSearch(
                    searchText: $dictionaryGetter.searchText,
                    locale: locale
                )
                .padding()
                
                DictionaryLocalListViewList(
                    locale: locale,
                    style: style,
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
                    onImport: { isShowingImportSheet = true },
                    onDownload: { isShowingRemoteList = true }
                )
                .padding(.bottom, 80)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        // Present details view when a dictionary is selected.
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryLocalDetails(
                dictionary: dictionary,
                isPresented: .constant(true),
                refresh: {
                    dictionaryGetter.resetPagination()
                }
            )
        }
        // Present import view.
        .fullScreenCover(isPresented: $isShowingImportSheet) {
            DictionaryImport(isPresented: $isShowingImportSheet)
        }
        // Present remote list view.
        .fullScreenCover(isPresented: $isShowingRemoteList) {
            DictionaryRemoteList()
        }
    }
}
