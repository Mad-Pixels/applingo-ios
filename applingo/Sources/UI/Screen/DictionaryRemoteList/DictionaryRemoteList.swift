import SwiftUI

struct DictionaryRemoteList: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locale = DictionaryRemoteListLocale()
    @StateObject private var dictionaryGetter = DictionaryFetcher()
    @State private var apiRequestParams = ApiModelDictionaryQueryRequest()
    @State private var selectedDictionary: DatabaseModelDictionary?
    @State private var isShowingFilterView = false
    @State private var isPressedTrailing = false

    @Binding var isPresented: Bool

    var body: some View {
        BaseScreen(
            screen: .DictionaryRemoteList,
            title: locale.navigationTitle
        ) {
            VStack(spacing: 0) {
                DictionaryRemoteListViewSearch(
                    searchText: $dictionaryGetter.searchText,
                    locale: locale
                )
                .padding()

                DictionaryRemoteListViewList(
                    locale: locale,
                    dictionaryGetter: dictionaryGetter,
                    onDictionarySelect: { dictionary in
                        selectedDictionary = dictionary
                    }
                )
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 42)
                }
            }
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
            DictionaryRemoteDetails(
                dictionary: dictionary,
                isPresented: .constant(true)
            )
            .environmentObject(ThemeManager.shared)
            .environmentObject(LocaleManager.shared)
        }
        .onAppear {
            //dictionaryGetter.setFrame(.dictionaryRemoteList)
            dictionaryGetter.resetPagination(with: apiRequestParams)
        }
        .onChange(of: apiRequestParams) { newParams in
            dictionaryGetter.resetPagination(with: newParams)
        }
    }
}
