import SwiftUI

struct DictionaryDetailView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    
    @State private var editedDictionary: DictionaryItemModel
    @State private var isShowingErrorAlert = false
    @State private var isEditing = false

    @Binding var isPresented: Bool
    let onSave: (DictionaryItemModel, @escaping (Result<Void, Error>) -> Void) -> Void
    private let originalDictionary: DictionaryItemModel

    init(
        dictionary: DictionaryItemModel,
        isPresented: Binding<Bool>,
        onSave: @escaping (DictionaryItemModel, @escaping (Result<Void, Error>) -> Void) -> Void
    ) {
        _editedDictionary = State(initialValue: dictionary)
        _isPresented = isPresented
        self.onSave = onSave
        self.originalDictionary = dictionary
    }

    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)

                Form {
                    Section(header: Text(LanguageManager.shared.localizedString(for: "Dictionary"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Display Name").capitalizedFirstLetter,
                                text: $editedDictionary.displayName,
                                isEditing: isEditing,
                                theme: theme,
                                icon: "book"
                            )
                            CompTextEditorView(
                                placeholder: LanguageManager.shared.localizedString(for: "Description").capitalizedFirstLetter,
                                text: Binding<String>(
                                    get: {
                                        editedDictionary.description
                                    },
                                    set: { newValue in
                                        editedDictionary.description = newValue.isEmpty ? "" : newValue
                                    }
                                ),
                                isEditing: isEditing,
                                theme: theme,
                                icon: "scroll"
                            )
                            .frame(height: 150)
                        }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Category"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Category").capitalizedFirstLetter,
                                text: $editedDictionary.category,
                                isEditing: isEditing,
                                theme: theme,
                                icon: "cube"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Subcategory").capitalizedFirstLetter,
                                text: $editedDictionary.subcategory,
                                isEditing: isEditing,
                                theme: theme,
                                icon: "square.3.layers.3d"
                            )
                        }

                    Section(header: Text(LanguageManager.shared.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Author").capitalizedFirstLetter,
                                text: $editedDictionary.author,
                                isEditing: isEditing,
                                theme: theme,
                                icon: "person"
                            )
                            CompTextFieldView(
                                placeholder: LanguageManager.shared.localizedString(for: "Created At").capitalizedFirstLetter,
                                text: .constant(editedDictionary.formattedCreatedAt),
                                isEditing: false,
                                theme: theme
                            )
                        }
                }
                Spacer()
            }
            .onAppear {
                FrameManager.shared.setActiveFrame(.dictionaryDetail)
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "Details").capitalizedFirstLetter)
            .navigationBarItems(
                leading: Button(
                    isEditing ? LanguageManager.shared.localizedString(for: "Cancel").capitalizedFirstLetter :
                        LanguageManager.shared.localizedString(for: "Close").capitalizedFirstLetter
                ) {
                    if isEditing {
                        isEditing = false
                        editedDictionary = originalDictionary
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                trailing: Button(isEditing ? LanguageManager.shared.localizedString(for: "Save").capitalizedFirstLetter :
                                    LanguageManager.shared.localizedString(for: "Edit").capitalizedFirstLetter
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
                    title: Text(LanguageManager.shared.localizedString(for: "Error")),
                    message: Text("Failed to update the dictionary due to database issues."),
                    dismissButton: .default(Text(LanguageManager.shared.localizedString(for: "Close")))
                )
            }
        }
    }

    private func updateDictionary(_ dictionary: DictionaryItemModel) {
        let previousDictionary = editedDictionary

        onSave(dictionary) { result in
            switch result {
            case .success:
                self.isEditing = false
                self.presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                if let appError = error as? AppErrorModel {
                    ErrorManager.shared.setError(appError: appError, frame: .dictionaryDetail, source: .dictionaryUpdate)
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
