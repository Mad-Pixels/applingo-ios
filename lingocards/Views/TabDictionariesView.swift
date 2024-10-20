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
    let theme = ThemeProvider.shared.currentTheme()
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Общий фон

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
                                            .foregroundColor(theme.textColor) // Цвет текста по теме

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
                                    .modifier(StatusModifier(isActive: dictionary.isActive) { newStatus in
                                        updateDictionaryStatus(dictionary, newStatus: newStatus)
                                    })
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete(perform: deleteDictionary)
                        }
                        .listStyle(PlainListStyle())
                    }

                    Spacer()
                }
                
                ButtonFloating(action: {
                    addDictionary()
                }, imageName: "plus")
            }
            .navigationTitle(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
            .navigationBarTitleDisplayMode(.large) // Единый стиль заголовка
            .onAppear {
                tabManager.setActiveTab(.dictionaries)
                if tabManager.isActive(tab: .dictionaries) {
                    viewModel.getDictionaries()
                }
            }
            .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
                if newTab != .learn {
                    tabManager.deactivateTab(.learn)
                }
            })
            .modifier(ErrModifier(currentError: errorManager.currentError) { newError in
                if let error = newError, error.tab == .dictionaries, error.source == .deleteDictionary {
                    isShowingAlert = true
                    alertMessage = error.errorDescription ?? ""
                }
            })
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

    private func addDictionary() {
        isShowingAddView = true
    }
}
