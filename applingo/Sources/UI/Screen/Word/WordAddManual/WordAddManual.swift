import SwiftUI

struct WordAddManual: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var isPresented: Bool
    
    @StateObject private var dictionaryAction = DictionaryAction()
    @StateObject private var locale = WordAddManualLocale()
    @StateObject private var wordsAction = WordAction()
    @StateObject private var style: WordAddManualStyle
    
    @State private var dictionaryRefs: [DatabaseModelDictionaryRef] = []
    @State private var selectedDictionary: DatabaseModelDictionaryRef?
    @State private var wordItem = DatabaseModelWord.new()
    @State private var descriptionText: String = ""
    @State private var hintText: String = ""
    @State private var isPressedTrailing = false
    @State private var isPressedLeading = false
    
    private let refresh: () -> Void

    /// Initializes the WordAddManual.
    /// - Parameters:
    ///   - isPresented: Binding to control the presentation state.
    ///   - refresh: Closure executed after a successful save.
    ///   - style: The style for the view. Defaults to themed style using the current theme.
    init(
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: WordAddManualStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
        self._isPresented = isPresented
        self.refresh = refresh
    }
    
    var body: some View {
        BaseScreen(
            screen: .WordAddManual,
            title: locale.screenTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    WordAddManualViewMain(
                        style: style,
                        locale: locale,
                        wordItem: $wordItem,
                        selectedDictionary: $selectedDictionary,
                        dictionaries: dictionaryRefs
                    )
                    
                    WordAddManualViewAdditional(
                        style: style,
                        locale: locale,
                        hint: $hintText,
                        description: $descriptionText
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .padding(.bottom, style.padding.bottom)
            .onAppear{
                wordsAction.setScreen(.WordAddManual)
                dictionaryAction.setScreen(.WordAddManual)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        isPressed: $isPressedLeading,
                        onTap: { presentationMode.wrappedValue.dismiss() },
                        style: .back(themeManager.currentThemeStyle)
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        isPressed: $isPressedTrailing,
                        onTap: { save() },
                        style: .save(themeManager.currentThemeStyle, disabled: isSaveDisabled)
                    )
                    .disabled(isSaveDisabled)
                }
            }
        }
        .onAppear {
            do {
                dictionaryRefs = try dictionaryAction.fetchRefs()
                if selectedDictionary == nil, let first = dictionaryRefs.first {
                    selectedDictionary = first
                }
            } catch {}
        }
        .onChange(of: hintText) { newValue in
            wordItem.hint = newValue
        }
        .onChange(of: descriptionText) { newValue in
            wordItem.description = newValue
        }
    }
    
    /// Determines whether the save button should be disabled.
    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        selectedDictionary == nil
    }
    
    /// Saves the new word by calling the word action.
    private func save() {
        guard let selectedDictionary = selectedDictionary else { return }
        
        let newWord = DatabaseModelWord(
            subcategory: selectedDictionary.subcategory,
            dictionary: selectedDictionary.guid,
            frontText: wordItem.frontText,
            backText: wordItem.backText,
            weight: wordItem.weight,
            success: wordItem.success,
            fail: wordItem.fail,
            description: descriptionText,
            hint: hintText,
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
