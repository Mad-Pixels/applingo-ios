import SwiftUI

struct WordAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var errorManager: ErrorManager
    @EnvironmentObject var themeManager: ThemeManager

    let dictionaries: [DictionaryItem]
    @Binding var isPresented: Bool
    let onSave: (WordItem, @escaping (Result<Void, Error>) -> Void) -> Void

    @State private var selectedDictionary: DictionaryItem?
    @State private var isShowingErrorAlert = false
    @State private var wordItem = WordItem.empty()

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundColor.edgesIgnoringSafeArea(.all)

                Form {
                    Section(header: Text(languageManager.localizedString(for: "Card"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                        CompTextField(
                            placeholder: languageManager.localizedString(for: "Word").capitalizedFirstLetter,
                            text: $wordItem.frontText,
                            isEditing: true,
                            theme: theme
                        )
                        CompTextField(
                            placeholder: languageManager.localizedString(for: "Definition").capitalizedFirstLetter,
                            text: $wordItem.backText,
                            isEditing: true,
                            theme: theme
                        )
                        CompDictionaryPickerView(
                            selectedDictionary: $selectedDictionary,
                            dictionaries: dictionaries
                        )
                    }

                    Section(header: Text(languageManager.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                        CompTextField(
                            placeholder: languageManager.localizedString(for: "Hint").capitalizedFirstLetter,
                            text: $wordItem.hint.unwrap(default: ""),
                            isEditing: true,
                            theme: theme
                        )
                        CompTextEditor(
                            placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                            text: $wordItem.description.unwrap(default: ""),
                            isEditing: true,
                            theme: theme
                        )
                        .frame(height: 150)
                    }
                }
                .navigationTitle(languageManager.localizedString(for: "AddWord").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(languageManager.localizedString(for: "Cancel").capitalizedFirstLetter) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button(languageManager.localizedString(for: "Save").capitalizedFirstLetter) {
                        wordSave()
                    }
                    .disabled(isSaveDisabled)
                )
                .alert(isPresented: $isShowingErrorAlert) {
                    CompAlertView(
                        title: languageManager.localizedString(for: "Error"),
                        message: errorManager.currentError?.errorDescription ?? "",
                        closeAction: {
                            errorManager.clearError()
                        },
                        theme: theme
                    )
                }
                .onAppear {
                    if selectedDictionary == nil, !dictionaries.isEmpty {
                        selectedDictionary = dictionaries.first
                    }
                }
            }
        }
    }

    private func wordSave() {
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
                    errorManager.setError(appError: appError, tab: .words, source: .saveWord)
                }
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
