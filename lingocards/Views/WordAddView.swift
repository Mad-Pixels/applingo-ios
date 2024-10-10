import SwiftUI

struct WordAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var errorManager: ErrorManager
    @State private var newWord = WordItem(id: 0, hashId: 0, tableName: "", frontText: "", backText: "", description: "", hint: "", createdAt: 0, salt: 0)
    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingErrorAlert = false
    @State private var isEditing = false

    @Binding var isPresented: Bool
    let onSave: (WordItem) -> Void
    let dictionaries: [DictionaryItem]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString(for: "Card"))) {
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Word").capitalizedFirstLetter,
                        text: $newWord.frontText,
                        isEditing: true
                    )
                    
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Definition").capitalizedFirstLetter,
                        text: $newWord.backText,
                        isEditing: true
                    )
                }

                Section(header: Text(languageManager.localizedString(for: "Additional"))) {
                    CompDictionaryPickerView(
                        selectedDictionary: $selectedDictionary,
                        dictionaries: dictionaries
                    )
                    
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Hint").capitalizedFirstLetter,
                        text: $newWord.hint.unwrap(default: ""),
                        isEditing: true
                    )
                    
                    AppTextEditor(
                        placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                        text: $newWord.description.unwrap(default: ""),
                        isEditing: true
                    )
                    .frame(height: 150)
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Add New Word").capitalizedFirstLetter)
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
                    message: Text(languageManager.localizedString(for: "Failed to save the word due to database issues.")),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close")))
                )
            }
        }
        .onAppear {
            if selectedDictionary == nil, !dictionaries.isEmpty {
                selectedDictionary = dictionaries.first
            }
        }
    }

    private func saveNewWord() {
        guard let selectedDictionary = selectedDictionary else {
            Logger.debug("[WordAddView]: No dictionary selected.")
            return
        }

        newWord.tableName = selectedDictionary.tableName
        onSave(newWord)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let error = errorManager.currentError, error.source == .saveWord {
                self.isShowingErrorAlert = true
            } else {
                self.isEditing = false
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private var isSaveDisabled: Bool {
        newWord.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        newWord.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        selectedDictionary == nil
    }
}
