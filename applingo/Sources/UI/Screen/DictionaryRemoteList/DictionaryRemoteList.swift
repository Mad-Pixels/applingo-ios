import SwiftUI

/// A view that displays a list of remote dictionaries with search, filter, and selection functionalities.
struct DictionaryRemoteList: View {
    
    // MARK: - Environment and State Properties
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locale = DictionaryRemoteListLocale()
    @StateObject private var dictionaryGetter = DictionaryFetcher()
    @State private var apiRequestParams = ApiModelDictionaryQueryRequest()
    @State private var selectedDictionary: ApiModelDictionaryItem?
    @State private var isShowingFilterView = false
    @State private var isPressedTrailing = false
    
    /// Style object for the remote list view.
    @StateObject private var style: DictionaryRemoteListStyle
    
    /// Binding flag to control the presentation of this view.
    @Binding var isPresented: Bool
    
    // MARK: - Initializer
    
    /// Initializes the DictionaryRemoteList view.
    /// - Parameters:
    ///   - isPresented: Binding to the presentation state.
    ///   - style: Optional style configuration; if nil, a themed style is used.
    init(isPresented: Binding<Bool>, style: DictionaryRemoteListStyle? = nil) {
        _isPresented = isPresented
        let initialStyle = style ?? DictionaryRemoteListStyle.themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryRemoteList,
            title: locale.navigationTitle
        ) {
            VStack(spacing: style.spacing) {
                DictionaryRemoteListViewSearch(
                    searchText: $dictionaryGetter.searchText,
                    locale: locale
                )
                .padding(style.padding)
                
                DictionaryRemoteListViewList(
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
        // Present the filter view sheet.
        .sheet(isPresented: $isShowingFilterView) {
            DictionaryRemoteFilter(apiRequestParams: $apiRequestParams)
                .environmentObject(ThemeManager.shared)
                .environmentObject(LocaleManager.shared)
        }
        // Present the remote details view sheet for the selected dictionary.
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryRemoteDetails(
                dictionary: dictionary,
                isPresented: .constant(true)
            )
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
