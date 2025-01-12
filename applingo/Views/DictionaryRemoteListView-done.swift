//import SwiftUI
//
//struct DictionaryRemoteListView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject private var dictionaryGetter: DictionaryRemoteGetterViewModel
//    @State private var apiRequestParams = ApiDictionaryQueryRequestModel()
//    @State private var selectedDictionary: DictionaryItemModel?
//    @State private var isShowingFilterView = false
//    @State private var isShowingAlert = false
//    @State private var errMessage: String = ""
//
//    @Binding var isPresented: Bool
//
//    init(isPresented: Binding<Bool>) {
//        self._isPresented = isPresented
//        _dictionaryGetter = StateObject(wrappedValue: DictionaryRemoteGetterViewModel())
//    }
//
//    var body: some View {
//        let theme = ThemeManager.shared.currentThemeStyle
//
//        NavigationView {
//            ZStack {
//                theme.backgroundPrimary.edgesIgnoringSafeArea(.all)
//
//                CompItemListView(
//                    items: $dictionaryGetter.dictionaries,
//                    isLoadingPage: dictionaryGetter.isLoadingPage,
//                    error: ErrorManager1.shared.currentError,
//                    onItemAppear: { dictionary in
//                        dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
//                    },
//                    onItemTap: { dictionary in
//                        selectedDictionary = dictionary
//                    },
//                    emptyListView: AnyView(
//                        CompEmptyListView(
//                            message: LanguageManager.shared.localizedString(for: "NoWordsAvailable")
//                        )
//                    ),
//                    rowContent: { dictionary in
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(dictionary.displayName)
//                                    .font(.headline)
//                                    .foregroundColor(theme.textPrimary)
//
//                                Text(dictionary.subTitle)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.vertical, 4)
//                        }
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            selectedDictionary = dictionary
//                        }
//                    }
//                )
//                .searchable(
//                    text: $dictionaryGetter.searchText,
//                    placement: .navigationBarDrawer(displayMode: .always),
//                    prompt: LanguageManager.shared.localizedString(for: "Search").capitalizedFirstLetter
//                )
//                .navigationTitle(LanguageManager.shared.localizedString(for: "Dictionaries").capitalizedFirstLetter)
//                .navigationBarItems(leading: Button(action: dismiss) {
//                    Text(LanguageManager.shared.localizedString(for: "Back").capitalizedFirstLetter)
//                        .foregroundColor(theme.accentPrimary)
//                })
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        CompToolbarMenuView(
//                            items: [
//                                CompToolbarMenuView.MenuItem(title: LanguageManager.shared.localizedString(
//                                    for: LanguageManager.shared.localizedString(for: "Filter").capitalizedFirstLetter
//                                ), systemImage: "line.horizontal.3.decrease.circle", action: {
//                                    isShowingFilterView = true
//                                })
//                            ]
//                        )
//                    }
//                }
//                .onAppear {
//                    AppStorage.shared.activeScreen = .dictionariesRemote
//                    dictionaryGetter.setFrame(.dictionaryRemoteList)
//                    dictionaryGetter.resetPagination()
//                    dictionaryGetter.resetPagination(with: apiRequestParams)
//
//                    NotificationCenter.default.addObserver(forName: .errorVisibilityChanged, object: nil, queue: .main) { _ in
//                        if let error = ErrorManager1.shared.currentError,
//                           error.frame == .dictionaryRemoteList,
//                           error.source == .dictionariesRemoteGet {
//                            isShowingAlert = true
//                            errMessage = error.errorDescription ?? ""
//                        }
//                    }
//                }
//                .onChange(of: apiRequestParams) { newParams in
//                    dictionaryGetter.resetPagination(with: newParams)
//                }
//                .alert(isPresented: $isShowingAlert) {
//                    Alert(
//                        title: Text(LanguageManager.shared.localizedString(for: "Error")),
//                        message: Text(errMessage),
//                        dismissButton: .default(Text(LanguageManager.shared.localizedString(for: "Close"))) {
//                            ErrorManager1.shared.clearError()
//                        }
//                    )
//                }
//                .sheet(isPresented: $isShowingFilterView) {
//                    DictionaryRemoteFilterView(apiRequestParams: $apiRequestParams)
//                }
//                .sheet(item: $selectedDictionary) { dictionary in
//                    DictionaryRemoteDetailView(
//                        dictionary: dictionary,
//                        isPresented: .constant(true)
//                    )
//                }
//            }
//            .navigationViewStyle(StackNavigationViewStyle())
//        }
//    }
//    
//    private func dismiss() {
//        AppStorage.shared.activeScreen = .dictionariesLocal
//        presentationMode.wrappedValue.dismiss()
//    }
//}
