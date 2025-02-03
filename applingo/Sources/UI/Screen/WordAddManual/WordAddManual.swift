import SwiftUI

/// A view that allows the user to add a new word manually.
/// It presents a form with main and additional sections and handles saving the new word.
struct WordAddManual: View {
    
    // MARK: - Environment and State Objects
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: WordAddManualStyle
    @StateObject private var locale = WordAddManualLocale()
    @StateObject private var wordsAction = WordAction()
    @StateObject private var dictionaryGetter = DictionaryGetter()
    
    // MARK: - Bindings and Local State
    
    /// Binding to control the presentation of this view.
    @Binding var isPresented: Bool
    let refresh: () -> Void
    
    /// Currently selected dictionary.
    @State private var selectedDictionary: DatabaseModelDictionary?
    @State private var wordItem = DatabaseModelWord.new()
    @State private var descriptionText: String = ""
    @State private var hintText: String = ""
    @State private var errorMessage: String = ""
    
    /// Flags for button animations.
    @State private var isPressedTrailing = false
    @State private var isPressedLeading = false
    
    /// Flag to show alerts.
    @State private var isShowingAlert = false
    
    // MARK: - Initializer
    
    /// Initializes the WordAddManual view.
    /// - Parameters:
    ///   - isPresented: Binding to control the presentation state.
    ///   - refresh: Closure executed after a successful save.
    ///   - style: Optional style; if nil, a themed style is used.
    init(
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: WordAddManualStyle? = nil
    ) {
        self._isPresented = isPresented
        self.refresh = refresh
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(
            screen: .WordAddManual,
            title: locale.navigationTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    WordAddManualViewMain(
                        wordItem: $wordItem,
                        selectedDictionary: $selectedDictionary,
                        dictionaries: dictionaryGetter.dictionaries,
                        locale: locale,
                        style: style
                    )

                    WordAddManualViewAdditional(
                        hint: $hintText,
                        description: $descriptionText,
                        locale: locale,
                        style: style
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        style: .back(ThemeManager.shared.currentThemeStyle),
                        onTap: { presentationMode.wrappedValue.dismiss() },
                        isPressed: $isPressedLeading
                    )
                }
                // Save button
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: .save(ThemeManager.shared.currentThemeStyle, disabled: isSaveDisabled),
                        onTap: { save() },
                        isPressed: $isPressedTrailing
                    )
                    .disabled(isSaveDisabled)
                }
            }
        }
        .onChange(of: hintText) { wordItem.hint = $0 }
        .onChange(of: descriptionText) { wordItem.description = $0 }
        .onChange(of: dictionaryGetter.dictionaries) { dictionaries in
            if selectedDictionary == nil {
                selectedDictionary = dictionaries.first
            }
        }
    }
    
    // MARK: - Helper Computed Properties
    
    /// Determines whether the save button should be disabled.
    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    
    /// Saves the new word by calling the word action.
    private func save() {
        guard let selectedDictionary = selectedDictionary else { return }
        
        let newWord = DatabaseModelWord(
            dictionary: selectedDictionary.guid,
            frontText: wordItem.frontText,
            backText: wordItem.backText,
            weight: wordItem.weight,
            success: wordItem.success,
            fail: wordItem.fail,
            description: descriptionText.isEmpty ? "" : descriptionText,
            hint: hintText.isEmpty ? "" : hintText,
            created: wordItem.created,
            id: wordItem.id
        )
        
        wordsAction.save(newWord) { result in
            if case .success = result {
                presentationMode.wrappedValue.dismiss()
                refresh()
            }
        }
    }
}
