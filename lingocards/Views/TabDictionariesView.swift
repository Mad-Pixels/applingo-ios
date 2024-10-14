import SwiftUI

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @StateObject private var viewModel = TabDictionariesViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var selectedDictionary: DictionaryItem?
    @State private var alertMessage: String = ""
    @State private var isShowingAddView = false
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
                        ForEach($viewModel.dictionaries, id: \.id) { $dictionary in
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
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedDictionary = dictionary
                                }

                                Toggle(isOn: $dictionary.isActive) {
                                    EmptyView()
                                }
                                .toggleStyle(CheckboxToggleStyle())
                                .onChange(of: dictionary.isActive) { oldStatus, newStatus in
                                    updateDictionaryStatus(dictionary, newStatus: newStatus)
                                }
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
            .onChange(of: tabManager.activeTab) { _, newTab in
                if newTab != .dictionaries {
                    tabManager.deactivateTab(.dictionaries)
                }
            }
            .onChange(of: errorManager.currentError) { _, newError in
                if let error = newError, error.tab == .dictionaries, error.source == .deleteDictionary {
                    isShowingAlert = true
                    alertMessage = error.errorDescription ?? ""
                }
            }
            .overlay(
                ButtonFloating(action: {
                    addDictionary()
                }, imageName: "plus")
            )
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(languageManager.localizedString(for: "Error")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close"))) {
                        errorManager.clearError()
                    }
                )
            }
        }
        .sheet(isPresented: $isShowingAddView) {
            DictionaryAddView(isPresented: $isShowingAddView)
                .environmentObject(languageManager)
        }
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryDetailView(
                dictionary: dictionary,
                isPresented: .constant(true),
                onSave: { updatedDictionary, completion in
                    viewModel.updateDictionary(updatedDictionary, completion: completion)
                }
            )
        }
    }

    private func deleteDictionary(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = viewModel.dictionaries[index]
            viewModel.deleteDictionary(dictionary)
        }
    }

    private func updateDictionaryStatus(_ dictionary: DictionaryItem, newStatus: Bool) {
        viewModel.updateDictionaryStatus(dictionary.id, newStatus: newStatus) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    return
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    isShowingAlert = true

                    if let index = viewModel.dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
                        viewModel.dictionaries[index].isActive.toggle()
                    }
                }
            }
        }
    }

    private func addDictionary() {
        isShowingAddView = true
    }
}
