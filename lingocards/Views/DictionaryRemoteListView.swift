import SwiftUI

struct DictionaryRemoteListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: DictionaryRemoteGetterViewModel

    @State private var apiRequestParams = DictionaryQueryRequest(isPrivate: false)
    @State private var selectedDictionary: DictionaryItemModel?
    @State private var isShowingFilterView = false
    @State private var errMessage: String = ""

    @Binding var isPresented: Bool

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        _viewModel = StateObject(wrappedValue: DictionaryRemoteGetterViewModel())
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                CompItemListView(
                    items: $viewModel.dictionaries,
                    isLoadingPage: viewModel.isLoadingPage,
                    error: ErrorManager.shared.currentError,
                    onItemAppear: { dictionary in
                        viewModel.loadMoreDictionariesIfNeeded(currentItem: dictionary)
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
                    text: $viewModel.searchText,
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
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.dictionaryRemoteList)
                    if FrameManager.shared.isActive(frame: .dictionaryRemoteList) {
                        viewModel.setFrame(.dictionaryRemoteList)
                        viewModel.resetPagination()
                    }
                }
                .onChange(of: apiRequestParams) { newParams in
                    viewModel.resetPagination()
                    viewModel.get(queryRequest: newParams)
                }
                .modifier(ErrModifier(currentError: ErrorManager.shared.currentError) { newError in
                    if let error = newError, error.frame == .dictionaryRemoteList, error.source == .dictionariesRemoteGet {
                        errMessage = error.errorDescription ?? "error"
                    }
                })
                .sheet(isPresented: $isShowingFilterView) {
                    DictionaryRemoteFilterView(apiRequestParams: $apiRequestParams)
                        .environmentObject(LanguageManager.shared)
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
