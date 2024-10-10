import SwiftUI

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @StateObject private var viewModel = TabDictionariesViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var isShowingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if let error = errorManager.currentError, errorManager.isVisible(for: .dictionaries, source: .getDictionaries) {
                    Text(error.errorDescription ?? "")
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                }

                if viewModel.dictionaries.isEmpty && !errorManager.isErrorVisible {
                    Spacer()
                    Text(languageManager.localizedString(for: "NoDictionariesAvailable"))
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.dictionaries) { dictionary in
                            VStack(alignment: .leading) {
                                Text(dictionary.displayName)
                                    .font(.headline)
                                    .padding(.vertical, 4)
                                
                                Text(dictionary.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: deleteDictionary)
                    }
                }

                Spacer()
            }
            .navigationTitle(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
            .onAppear {
                tabManager.setActiveTab(.dictionaries)
                if tabManager.isActive(tab: .dictionaries) {
                    viewModel.getDictionaries()
                }
            }
            .onChange(of: tabManager.activeTab) { oldTab, newTab in
                if newTab != .dictionaries {
                    tabManager.deactivateTab(.dictionaries)
                }
            }
            .onChange(of: errorManager.currentError) { _, newError in
                if let error = newError, error.tab == .dictionaries, error.source == .deleteDictionary {
                    isShowingAlert = true
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(languageManager.localizedString(for: "Error")),
                    message: Text(errorManager.currentError?.errorDescription ?? ""),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close"))) {
                        errorManager.clearError()
                    }
                )
            }
        }
    }

    private func deleteDictionary(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = viewModel.dictionaries[index]
            viewModel.deleteDictionary(dictionary)
        }
    }
}
