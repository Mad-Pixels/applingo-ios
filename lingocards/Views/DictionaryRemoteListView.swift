import SwiftUI

struct DictionaryRemoteList: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = TabDictionariesViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingFilterView = false
    @State private var alertMessage: String = ""
    @Binding var isPresented: Bool
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                if let error = errorManager.currentError, errorManager.isVisible(for: .dictionaries, source: .getRemoteDictionaries) {
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
                        // Используем CompPreloaderView для отображения pre-loader
                        CompPreloaderView()
                    } else {
                        List {
                            ForEach(viewModel.dictionaries, id: \.id) { dictionary in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(dictionary.displayName)
                                            .font(.headline)

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
                    }
                }

                Spacer()
            }
            .navigationTitle(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(languageManager.localizedString(for: "Back").capitalizedFirstLetter)
            },
            trailing: Button(action: {
                // Закрываем оба модальных окна
                isPresented = false
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(languageManager.localizedString(for: "Close").capitalizedFirstLetter)
            })
            .onAppear {
                isLoading = true
                viewModel.getRemoteDictionaries()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isLoading = false
                }
            }
            .onChange(of: errorManager.currentError) { _, newError in
                if let error = newError, error.tab == .dictionaries, error.source == .getRemoteDictionaries {
                    alertMessage = error.errorDescription ?? "error"
                }
            }
            .overlay(
                ButtonFloating(action: {
                    isShowingFilterView = true
                }, imageName: "line.horizontal.3.decrease.circle")
            )
            .sheet(isPresented: $isShowingFilterView) {
                DictionaryRemoteFilterView()
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
