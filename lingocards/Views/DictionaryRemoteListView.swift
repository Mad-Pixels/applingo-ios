import SwiftUI

struct DictionaryRemoteListView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var dictionaryGetter: DictionaryRemoteGetterViewModel
    @State private var apiRequestParams = DictionaryQueryRequest(isPrivate: false)
    @State private var selectedDictionary: DictionaryItemModel?
    @State private var isShowingFilterView = false
    @State private var isShowingAlert = false
    @State private var errMessage: String = ""

    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        _dictionaryGetter = StateObject(wrappedValue: DictionaryRemoteGetterViewModel())
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $dictionaryGetter.dictionaries,
                    isLoadingPage: dictionaryGetter.isLoadingPage,
                    error: ErrorManager.shared.currentError,
                    onItemAppear: { dictionary in
                        dictionaryGetter.loadMoreDictionariesIfNeeded(currentItem: dictionary)
                    },
                    onItemTap: { dictionary in
                        selectedDictionary = dictionary
                    },
                    emptyListView: AnyView(
                        Text(LanguageManager.shared.localizedString(for: "NoDictionariesAvailable"))
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                            .multilineTextAlignment(.center)
                    ),
                    rowContent: { dictionary in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(dictionary.displayName)
                                    .font(.headline)
                                    .foregroundColor(theme.baseTextColor)

                                Text(dictionary.subTitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 4)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDictionary = dictionary
                        }
                    }
                )
                .searchable(
                    text: $dictionaryGetter.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: LanguageManager.shared.localizedString(for: "Search").capitalizedFirstLetter
                )
                .navigationTitle(LanguageManager.shared.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(LanguageManager.shared.localizedString(for: "Back").capitalizedFirstLetter)
                        .foregroundColor(theme.accentColor)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenuView(
                            items: [
                                CompToolbarMenuView.MenuItem(title: LanguageManager.shared.localizedString(
                                    for: "Filter"
                                ), systemImage: "line.horizontal.3.decrease.circle", action: {
                                    isShowingFilterView = true
                                })
                            ]
                        )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.dictionaryRemoteList)
                    if FrameManager.shared.isActive(frame: .dictionaryRemoteList) {
                        dictionaryGetter.setFrame(.dictionaryRemoteList)
                        dictionaryGetter.resetPagination()
                    }

                    // Подписка на уведомление об изменении видимости ошибки
                    NotificationCenter.default.addObserver(forName: .errorVisibilityChanged, object: nil, queue: .main) { _ in
                        if let error = ErrorManager.shared.currentError,
                           error.frame == .dictionaryRemoteList, // Условие для frame
                           error.source == .dictionariesRemoteGet { // Условие для source
                            isShowingAlert = true
                            errMessage = error.errorDescription ?? ""
                        }
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self, name: .errorVisibilityChanged, object: nil)
                }
                .onChange(of: apiRequestParams) { newParams in
                    dictionaryGetter.resetPagination()
                    dictionaryGetter.get(queryRequest: newParams)
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text(LanguageManager.shared.localizedString(for: "Error")),
                        message: Text(errMessage),
                        dismissButton: .default(Text(LanguageManager.shared.localizedString(for: "Close"))) {
                            ErrorManager.shared.clearError()
                        }
                    )
                }
                .sheet(isPresented: $isShowingFilterView) {
                    DictionaryRemoteFilterView(apiRequestParams: $apiRequestParams)
                }
                .sheet(item: $selectedDictionary) { dictionary in
                    DictionaryRemoteDetailView(
                        dictionary: dictionary,
                        isPresented: .constant(true),
                        onDownload: {
                            Logger.debug("[DictionaryRemoteList]: Download button tapped for dictionary \(dictionary.displayName)")
                        }
                    )
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
