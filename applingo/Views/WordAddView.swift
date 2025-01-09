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
    @State private var hintText: String = ""
    @State private var descriptionText: String = ""

    init(isPresented: Binding<Bool>, refresh: @escaping () -> Void) {
        _dictionaryGetter = StateObject(wrappedValue: DictionaryLocalGetterViewModel())
        _wordsAction = StateObject(wrappedValue: WordsLocalActionViewModel())
        
        _isPresented = isPresented
        self.refresh = refresh
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        NavigationView {
            ZStack {
                theme.backgroundPrimary.edgesIgnoringSafeArea(.all)
                
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
                                    text: $hintText,
                                    isEditing: true,
                                    icon: "tag"
                                )
                                .onChange(of: hintText) { newValue in
                                    wordItem.hint = newValue
                                }
                                
                                CompTextEditorView(
                                    placeholder: LanguageManager.shared.localizedString(
                                        for: "Description"
                                    ).capitalizedFirstLetter,
                                    text: $descriptionText,
                                    isEditing: true,
                                    icon: "scroll"
                                )
                                .onChange(of: descriptionText) { newValue in
                                    wordItem.description = newValue
                                }
                                .frame(height: 150)
                            }
                            .padding(.vertical, 12)
                    }
                }
                .onAppear {
                    // Инициализация начальных значений
                    hintText = wordItem.hint ?? ""
                    descriptionText = wordItem.description ?? ""
                    
                    AppStorage.shared.activeScreen = .wordsAdd
                    dictionaryGetter.setFrame(.wordAdd)
                    wordsAction.setFrame(.wordAdd)
                    dictionaryGetter.get()
                }
                .onDisappear {
                    dictionaryGetter.clear()
                }
                .onReceive(NotificationCenter.default.publisher(for: .errorVisibilityChanged)) { _ in
                    if let error = ErrorManager1.shared.currentError,
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
                            ErrorManager1.shared.clearError()
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
        
        let newWord = WordItemModel(
            id: wordItem.id,
            tableName: selectedDictionary.tableName,
            frontText: wordItem.frontText,
            backText: wordItem.backText,
            description: descriptionText.isEmpty ? nil : descriptionText,
            hint: hintText.isEmpty ? nil : hintText,
            createdAt: wordItem.createdAt,
            success: wordItem.success,
            weight: wordItem.weight,
            fail: wordItem.fail
        )
        wordsAction.save(newWord) { result in
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
