import SwiftUI

struct WordAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var errorManager: ErrorManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var frameManager: FrameManager
    
    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel
    
    @Binding var isPresented: Bool
    let onSave: (WordItemModel, @escaping (Result<Void, Error>) -> Void) -> Void
    
    @State private var selectedDictionary: DictionaryItemModel?
    @State private var isShowingErrorAlert = false
    @State private var wordItem = WordItemModel.empty()

    init(isPresented: Binding<Bool>, onSave: @escaping (WordItemModel, @escaping (Result<Void, Error>) -> Void) -> Void) {
        self._isPresented = isPresented
        self.onSave = onSave
        
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let repository = RepositoryDictionary(dbQueue: dbQueue)
        _dictionaryGetter = StateObject(wrappedValue: DictionaryLocalGetterViewModel(repository: repository))
    }
    
    var body: some View {
        let theme = themeManager.currentThemeStyle
        
        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text(languageManager.localizedString(for: "Card"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            VStack {
                                CompTextFieldView(
                                    placeholder: languageManager.localizedString(for: "Word").capitalizedFirstLetter,
                                    text: $wordItem.frontText,
                                    isEditing: true,
                                    theme: theme,
                                    icon: "rectangle.and.pencil.and.ellipsis"
                                )
                                CompTextFieldView(
                                    placeholder: languageManager.localizedString(for: "Definition").capitalizedFirstLetter,
                                    text: $wordItem.backText,
                                    isEditing: true,
                                    theme: theme,
                                    icon: "translate"
                                )
                                CompPickerView(
                                    selectedValue: $selectedDictionary,
                                    items: dictionaryGetter.dictionaries,
                                    title: "",
                                    theme: theme
                                ) { dictionary in
                                    Text(dictionary!.displayName)
                                }
                            }
                            .padding(.vertical, 12)
                    }
                    
                    Section(header: Text(languageManager.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle(theme: theme))) {
                            VStack {
                                CompTextFieldView(
                                    placeholder: languageManager.localizedString(for: "Hint").capitalizedFirstLetter,
                                    text: $wordItem.hint.unwrap(default: ""),
                                    isEditing: true,
                                    theme: theme,
                                    icon: "tag"
                                )
                                CompTextEditorView(
                                    placeholder: languageManager.localizedString(for: "Description").capitalizedFirstLetter,
                                    text: $wordItem.description.unwrap(default: ""),
                                    isEditing: true,
                                    theme: theme,
                                    icon: "scroll"
                                )
                                .frame(height: 150)
                            }
                            .padding(.vertical, 12)
                    }
                }
                .onAppear {
                    frameManager.setActiveFrame(.wordAdd)
                    dictionaryGetter.setFrame(.wordAdd)
                    dictionaryGetter.get()
                    
                    if selectedDictionary == nil, !dictionaryGetter.dictionaries.isEmpty {
                        selectedDictionary = dictionaryGetter.dictionaries.first
                    }
                }
                .navigationTitle(languageManager.localizedString(for: "AddWord").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(languageManager.localizedString(for: "Cancel").capitalizedFirstLetter) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button(languageManager.localizedString(for: "Save").capitalizedFirstLetter) {
                        save()
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
            }
        }
    }
    
    private func save() {
        guard let selectedDictionary = selectedDictionary else {
            return
        }
        wordItem.tableName = selectedDictionary.tableName
        
        onSave(wordItem) { result in
            if case .success = result {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
