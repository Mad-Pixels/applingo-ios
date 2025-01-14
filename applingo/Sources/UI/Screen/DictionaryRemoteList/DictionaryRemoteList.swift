import SwiftUI

struct DictionaryRemoteList: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var locale = DictionaryRemoteListLocale()
    @StateObject private var dictionaryGetter = DictionaryRemoteGetterViewModel()
    @State private var apiRequestParams = ApiDictionaryQueryRequestModel()
    @State private var selectedDictionary: DictionaryItemModel?
    @State private var isShowingFilterView = false
    
    @Binding var isPresented: Bool
    
    var body: some View {
        BaseScreen(screen: .dictionariesRemote, title: locale.navigationTitle) {
            ZStack {
                VStack(spacing: 16) {
                    DictionaryRemoteListViewSearch(
                        searchText: $dictionaryGetter.searchText,
                        locale: locale
                    )
                    
                    DictionaryRemoteListViewList(
                        locale: locale,
                        dictionaryGetter: dictionaryGetter,
                        onDictionarySelect: { dictionary in
                            selectedDictionary = dictionary
                        }
                    )
                    
                    Spacer() // Чтобы список растягивался на всю высоту
                }
                .padding(.horizontal, 16)
                
                DictionaryRemoteListViewActions(
                    locale: locale,
                    onFilter: { isShowingFilterView = true }
                )
            }
            .navigationTitle(locale.navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButton(locale.backTitle) {
                dismiss()
            }
        }
        .onAppear {
            dictionaryGetter.setFrame(.dictionaryRemoteList)
            dictionaryGetter.resetPagination(with: apiRequestParams)
        }
        .onChange(of: apiRequestParams) { newParams in
            dictionaryGetter.resetPagination(with: newParams)
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
    }
    
    private func dismiss() {
        AppStorage.shared.activeScreen = .dictionariesLocal
        presentationMode.wrappedValue.dismiss()
    }
}


// TODO ВОТ ВСЕ КНОПКИ ТИПА ОТМЕНА, СОХРАНИТЬ НАДО БЫ ВОТ ТАК ОТДЕЛЬНО СДЕЛАТЬ!!
extension View {
    func navigationBarBackButton(_ title: String, action: @escaping () -> Void) -> some View {
        self.navigationBarItems(
            leading: Button(action: action) {
                Text(title)
            }
        )
    }
}
