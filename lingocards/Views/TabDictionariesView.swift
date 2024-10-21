import SwiftUI

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @StateObject private var viewModel = TabDictionariesViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var selectedDictionary: DictionaryItem?
    @State private var alertMessage: String = ""
    @State private var isShowingAlert = false
    @State private var isShowingFileImporter = false
    @State private var isShowingRemoteList = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                            ForEach(viewModel.dictionaries, id: \.uiID) { dictionary in
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
                                    .contentShape(Rectangle()) // Make the entire row tappable
                                    .onTapGesture {
                                        selectedDictionary = dictionary
                                    }

                                    Toggle(isOn: Binding(
                                        get: { dictionary.isActive },
                                        set: { newStatus in
                                            updateDictionaryStatus(dictionary, newStatus: newStatus)
                                        })
                                    ) {
                                        EmptyView()
                                    }
                                    .toggleStyle(CheckboxToggleStyle())
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteDictionary)
                        }
                    }

                    Spacer()
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            isShowingFileImporter = true
                        }) {
                            Label(languageManager.localizedString(for: "ImportCSV"), systemImage: "tray.and.arrow.down")
                        }
                        Button(action: {
                            isShowingRemoteList = true
                        }) {
                            Label(languageManager.localizedString(for: "Download"), systemImage: "arrow.down.circle")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .onAppear {
                tabManager.setActiveTab(.dictionaries)
                if tabManager.isActive(tab: .dictionaries) {
                    viewModel.getDictionaries()
                }
            }
            .onChange(of: tabManager.activeTab) { newTab in
                if newTab != .dictionaries {
                    tabManager.deactivateTab(.dictionaries)
                }
            }
            .onChange(of: errorManager.currentError) { newError in
                if let error = newError, error.tab == .dictionaries, error.source == .deleteDictionary {
                    isShowingAlert = true
                    alertMessage = error.errorDescription ?? ""
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text(languageManager.localizedString(for: "Error")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close"))) {
                        errorManager.clearError()
                    }
                )
            }
            .fileImporter(
                isPresented: $isShowingFileImporter,
                allowedContentTypes: [.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        importCSV(from: url)
                    }
                case .failure(let error):
                    Logger.debug("Failed to import file: \(error)")
                }
            }
            .fullScreenCover(isPresented: $isShowingRemoteList) {
                DictionaryRemoteList(isPresented: $isShowingRemoteList)
                    .environmentObject(languageManager)
            }
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
            
            if dictionary.tableName != "Internal" {
                viewModel.deleteDictionary(dictionary)
            } else {
                alertMessage = languageManager.localizedString(for: "CannotDeleteInternalDictionary")
                isShowingAlert = true
            }
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

    private func importCSV(from url: URL) {
        do {
            try databaseManager.importCSVFile(at: url)
        } catch {
            Logger.debug("Failed to import CSV file: \(error)")
        }
    }
}
