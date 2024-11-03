import SwiftUI

struct WordAddView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var wordsAction: WordsLocalActionViewModel
    @StateObject private var dictionaryGetter: DictionaryLocalGetterViewModel
    
    @Binding var isPresented: Bool
    let refresh: () -> Void
    
    @State private var selectedDictionary: DictionaryItemModel?
    @State private var wordItem = WordItemModel.empty()
    @State private var errorMessage: String = ""
    @State private var isShowingAlert = false

    init(isPresented: Binding<Bool>, refresh: @escaping () -> Void) {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        let dictionaryRepository = RepositoryDictionary(dbQueue: dbQueue)
        _dictionaryGetter = StateObject(wrappedValue: DictionaryLocalGetterViewModel(repository: dictionaryRepository))
        let wordRepository = RepositoryWord(dbQueue: dbQueue)
        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel(repository: wordRepository))
        
        _isPresented = isPresented
        self.refresh = refresh
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text(LanguageManager.shared.localizedString(for: "Card"))
                        .modifier(HeaderBlockTextStyle())) {
                            VStack {
                                CompTextFieldView(
                                    placeholder: LanguageManager.shared.localizedString(
                                        for: "Word"
                                    ).capitalizedFirstLetter,
                                    text: $wordItem.frontText,
                                    isEditing: true,
                                    icon: "rectangle.and.pencil.and.ellipsis"
                                )
                                CompTextFieldView(
                                    placeholder: LanguageManager.shared.localizedString(
                                        for: "Definition"
                                    ).capitalizedFirstLetter,
                                    text: $wordItem.backText,
                                    isEditing: true,
                                    icon: "translate"
                                )
                                CompPickerView(
                                    selectedValue: $selectedDictionary,
                                    items: dictionaryGetter.dictionaries,
                                    title: ""
                                ) { dictionary in
                                    Text(dictionary!.displayName)
                                }
                            }
                            .padding(.vertical, 12)
                    }
                    
                    Section(header: Text(LanguageManager.shared.localizedString(for: "Additional"))
                        .modifier(HeaderBlockTextStyle())) {
                            VStack {
                                CompTextFieldView(
                                    placeholder: LanguageManager.shared.localizedString(
                                        for: "Hint"
                                    ).capitalizedFirstLetter,
                                    text: $wordItem.hint.unwrap(default: ""),
                                    isEditing: true,
                                    icon: "tag"
                                )
                                CompTextEditorView(
                                    placeholder: LanguageManager.shared.localizedString(
                                        for: "Description"
                                    ).capitalizedFirstLetter,
                                    text: $wordItem.description.unwrap(default: ""),
                                    isEditing: true,
                                    icon: "scroll"
                                )
                                .frame(height: 150)
                            }
                            .padding(.vertical, 12)
                    }
                }
                .onAppear {
                    FrameManager.shared.setActiveFrame(.wordAdd)
                    dictionaryGetter.setFrame(.wordAdd)
                    wordsAction.setFrame(.wordAdd)
                    dictionaryGetter.get()
                }
                .onDisappear {
                    dictionaryGetter.clear()
                }
                .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
                    if let error = ErrorManager.shared.currentError,
                       error.frame == .wordAdd {
                        errorMessage = error.localizedMessage
                        isShowingAlert = true
                    }
                }
                .onChange(of: dictionaryGetter.dictionaries) { dictionaries in
                    if selectedDictionary == nil, let firstDictionary = dictionaries.first {
                        selectedDictionary = firstDictionary
                    }
                }
                .navigationTitle(LanguageManager.shared.localizedString(for: "AddWord").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    leading: Button(LanguageManager.shared.localizedString(for: "Cancel").capitalizedFirstLetter) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailing: Button(LanguageManager.shared.localizedString(for: "Save").capitalizedFirstLetter) {
                        save()
                    }
                    .disabled(isSaveDisabled)
                )
                .alert(isPresented: $isShowingAlert) {
                    CompAlertView(
                        title: LanguageManager.shared.localizedString(for: "Error"),
                        message: errorMessage,
                        closeAction: {
                            ErrorManager.shared.clearError()
                        }
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
        wordsAction.save(wordItem) { result in
            if case .success = result {
                presentationMode.wrappedValue.dismiss()
                refresh()
            }
        }
    }
    
    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
