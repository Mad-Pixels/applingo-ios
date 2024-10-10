import SwiftUI

struct TabDictionariesView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var tabManager: TabManager
    @StateObject private var viewModel = TabDictionariesViewModel()
    @StateObject private var errorManager = ErrorManager.shared
    @State private var isShowingAlert = false
    @State private var alertMessage: String = ""
    @State private var selectedDictionary: DictionaryItem?

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

                                    Text(dictionary.subcategory)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedDictionary = dictionary
                                }

                                // Добавление Toggle с чекбоксом для изменения статуса словаря
                                Toggle(isOn: $dictionary.isActive) {
                                    EmptyView()
                                }
                                .toggleStyle(CheckboxToggleStyle()) // Используем CheckboxToggleStyle для стилизации как чекбокс
                                .onChange(of: dictionary.isActive) { newStatus in
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
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryDetailView(
                dictionary: dictionary,
                isPresented: .constant(true), // Постоянное значение true для управления отображением листа
                onSave: { updatedDictionary, completion in
                    viewModel.updateDictionary(updatedDictionary, completion: completion)
                }
            )
        }
    }

    // Метод для удаления словаря
    private func deleteDictionary(at offsets: IndexSet) {
        offsets.forEach { index in
            let dictionary = viewModel.dictionaries[index]
            viewModel.deleteDictionary(dictionary)
        }
    }

    // Метод для обновления статуса словаря и обработки ошибок
    private func updateDictionaryStatus(_ dictionary: DictionaryItem, newStatus: Bool) {
        viewModel.updateDictionaryStatus(dictionary.id, newStatus: newStatus) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    Logger.debug("[TabDictionariesView]: Successfully updated status for dictionary \(dictionary.displayName).")
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    isShowingAlert = true

                    // Если ошибка, возвращаем прежнее состояние
                    if let index = viewModel.dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
                        viewModel.dictionaries[index].isActive.toggle()
                    }
                }
            }
        }
    }
}
