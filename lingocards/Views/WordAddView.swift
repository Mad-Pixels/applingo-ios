import SwiftUI

struct WordAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var errorManager: ErrorManager

    let dictionaries: [DictionaryItem]
    @Binding var isPresented: Bool
    let onSave: (WordItem, @escaping (Result<Void, Error>) -> Void) -> Void

    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingErrorAlert = false
    @State private var wordItem = WordItem.empty()
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString(for: "Card"))) {
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Word").capitalizedFirstLetter,
                        text: $wordItem.frontText,
                        isEditing: true
                    )

                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Definition").capitalizedFirstLetter,
                        text: $wordItem.backText,
                        isEditing: true
                    )
                    
                    CompDictionaryPickerView(
                        selectedDictionary: $selectedDictionary,
                        dictionaries: dictionaries
                    )
                }

                Section(header: Text(languageManager.localizedString(for: "Additional"))) {
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Hint").capitalizedFirstLetter,
                        text: $wordItem.hint.unwrap(default: ""),
                        isEditing: true
                    )
                    
                    AppTextEditor(
                        placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                        text: $wordItem.description.unwrap(default: ""),
                        isEditing: true
                    )
                    .frame(height: 150)
                }
            }
            .navigationTitle(languageManager.localizedString(for: "AddWord").capitalizedFirstLetter)
            .navigationBarItems(
                leading: Button(languageManager.localizedString(for: "Cancel").capitalizedFirstLetter) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(languageManager.localizedString(for: "Save").capitalizedFirstLetter) {
                    saveNewWord()
                }
                .disabled(isSaveDisabled)
            )
            .alert(isPresented: $isShowingErrorAlert) {
                Alert(
                    title: Text(languageManager.localizedString(for: "Error")),
                    message: Text(errorMessage),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close")))
                )
            }
            .onAppear {
                if selectedDictionary == nil, !dictionaries.isEmpty {
                    selectedDictionary = dictionaries.first
                }
            }
        }
    }

    private func saveNewWord() {
        guard let selectedDictionary = selectedDictionary else {
            return
        }
        wordItem.tableName = selectedDictionary.tableName

        onSave(wordItem) { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                if let appError = error as? AppError {
                    ErrorManager.shared.setError(appError: appError, tab: .words, source: .saveWord)
                }
                errorMessage = error.localizedDescription
                isShowingErrorAlert = true
            }
        }
    }

    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        selectedDictionary == nil
    }
}
