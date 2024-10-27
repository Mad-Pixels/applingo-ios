import SwiftUI

struct DictionaryRemoteListView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = DictionaryRemoteGetterViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    
    @State private var apiRequestParams = DictionaryQueryRequest(isPublic: true)
    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingFilterView = false
    @State private var isLoading: Bool = true
    @State private var errMessage: String = ""
    
    @Binding var isPresented: Bool
    
    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                VStack {
                    if let error = errorManager.currentError, errorManager.isVisible(for: .dictionaries, source: .dictionariesRemoteGet) {
                        Text(error.errorDescription ?? "")
                            .foregroundColor(.red)
                            .padding()
                            .multilineTextAlignment(.center)
                    }

                    if viewModel.dictionaries.isEmpty && !errorManager.isErrorVisible && !isLoading {
                        Spacer()
                        Text(languageManager.localizedString(for: "NoDictionariesAvailable"))
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                            .multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        if isLoading {
                            CompPreloaderView()
                        } else {
                            List {
                                ForEach(viewModel.dictionaries, id: \.id) { dictionary in
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
                            }
                            .listStyle(PlainListStyle())
                        }
                    }

                    Spacer()
                }
                .navigationTitle(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(languageManager.localizedString(for: "Back").capitalizedFirstLetter)
                        .foregroundColor(theme.accentColor)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CompToolbarMenu(
                            items: [
                                CompToolbarMenu.MenuItem(title: languageManager.localizedString(for: "Filter"), systemImage: "line.horizontal.3.decrease.circle", action: {
                                    isShowingFilterView = true
                                })
                            ],
                            theme: theme
                        )
                    }
                }
                .onAppear {
                    isLoading = true
                    viewModel.getRemoteDictionaries(query: apiRequestParams)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isLoading = false
                    }
                }
                .onChange(of: apiRequestParams) { newParams in
                    Logger.debug("[DictionaryRemoteList]: apiRequestParams changed, fetching remote dictionaries")
                    isLoading = true
                    viewModel.getRemoteDictionaries(query: newParams)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isLoading = false
                    }
                }
                .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                    if let error = newError, error.tab == .dictionaries, error.source == .dictionariesRemoteGet {
                        errMessage = error.errorDescription ?? "error"
                    }
                })
                .sheet(isPresented: $isShowingFilterView) {
                    DictionaryRemoteFilterView(apiRequestParams: $apiRequestParams)
                        .environmentObject(languageManager)
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
