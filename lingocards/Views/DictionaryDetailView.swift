import SwiftUI

struct DictionaryDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var languageManager: LanguageManager
    @State private var editedDictionary: DictionaryItem
    @State private var isShowingErrorAlert = false
    @State private var isEditing = false

    @Binding var isPresented: Bool
    let onSave: (DictionaryItem, @escaping (Result<Void, Error>) -> Void) -> Void

    private let originalDictionary: DictionaryItem

    init(dictionary: DictionaryItem, isPresented: Binding<Bool>, onSave: @escaping (DictionaryItem, @escaping (Result<Void, Error>) -> Void) -> Void) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onSave = onSave
        self.originalDictionary = dictionary
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString(for: "Dictionary"))) {
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Display Name").capitalizedFirstLetter,
                        text: $editedDictionary.displayName,
                        isEditing: isEditing
                    )
                    
                    AppTextEditor(
                        placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                        text: $editedDictionary.description,
                        isEditing: isEditing
                    )
                    .frame(height: 150)
                }
                
                Section(header: Text(languageManager.localizedString(for: "Category"))) {
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Category").capitalizedFirstLetter,
                        text: $editedDictionary.category,
                        isEditing: isEditing
                    )

                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Subcategory").capitalizedFirstLetter,
                        text: $editedDictionary.subcategory,
                        isEditing: isEditing
                    )
                }
                
                Section(header: Text(languageManager.localizedString(for: "Additional"))) {
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Author").capitalizedFirstLetter,
                        text: $editedDictionary.author,
                        isEditing: isEditing
                    )
                    
                    AppTextField(
                        placeholder: languageManager.localizedString(for: "Created At").capitalizedFirstLetter,
                        text: .constant(editedDictionary.formattedCreatedAt),
                        isEditing: false
                    )
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarItems(
                leading: Button(
                    isEditing ? languageManager.localizedString(for: "Cancel").capitalizedFirstLetter :
                        languageManager.localizedString(for: "Close").capitalizedFirstLetter
                ) {
                    if isEditing {
                        isEditing = false
                        editedDictionary = originalDictionary
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button(isEditing ? languageManager.localizedString(for: "Save").capitalizedFirstLetter :
                                    languageManager.localizedString(for: "Edit").capitalizedFirstLetter
                ) {
                    if isEditing {
                        updateDictionary(editedDictionary)
                    } else {
                        isEditing = true
                    }
                }
                .disabled(isEditing && isSaveDisabled)
            )
            .animation(.easeInOut, value: isEditing)
            .alert(isPresented: $isShowingErrorAlert) {
                Alert(
                    title: Text(languageManager.localizedString(for: "Error")),
                    message: Text("Failed to update the dictionary due to database issues."),
                    dismissButton: .default(Text(languageManager.localizedString(for: "Close")))
                )
            }
        }
    }

    private func updateDictionary(_ dictionary: DictionaryItem) {
        let previousDictionary = editedDictionary

        onSave(dictionary) { result in
            switch result {
            case .success:
                self.isEditing = false
                self.presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                if let appError = error as? AppError {
                    ErrorManager.shared.setError(appError: appError, tab: .dictionaries, source: .updateDictionary)
                }
                self.editedDictionary = previousDictionary
                self.isShowingErrorAlert = true
            }
        }
    }

    private var isSaveDisabled: Bool {
        editedDictionary.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editedDictionary.category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editedDictionary.subcategory.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editedDictionary.author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editedDictionary.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
