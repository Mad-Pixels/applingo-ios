import SwiftUI
import Foundation

/// A view that allows the user to add a new word manually.
/// It presents a form with main and additional sections and handles saving the new word.
struct WordAddManual: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    let refresh: () -> Void

    // MARK: - State Objects
    @StateObject private var style: WordAddManualStyle
    @StateObject private var locale = WordAddManualLocale()
    @StateObject private var wordsAction = WordAction()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    // MARK: - Local State
    @Binding var isPresented: Bool
    @State private var selectedDictionary: DatabaseModelDictionaryRef?
    @State private var dictionaryRefs: [DatabaseModelDictionaryRef] = []
    
    @State private var wordItem = DatabaseModelWord.new()
    @State private var descriptionText: String = ""
    @State private var hintText: String = ""
    
    // Flags for button animations
    @State private var isPressedTrailing = false
    @State private var isPressedLeading = false
    
    // MARK: - Initializer
    /// Initializes the WordAddManual view.
    /// - Parameters:
    ///   - style: Optional style; if nil, a themed style is used.
    ///   - isPresented: Binding to control the presentation state.
    ///   - refresh: Closure executed after a successful save.
    init(
        style: WordAddManualStyle? = nil,
        isPresented: Binding<Bool>,
        refresh: @escaping () -> Void
    ) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        self._isPresented = isPresented
        self.refresh = refresh
    }
    
    // MARK: - Body
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
                        style: .back(ThemeManager.shared.currentThemeStyle),
                        onTap: { presentationMode.wrappedValue.dismiss() },
                        isPressed: $isPressedLeading
                    )
                }
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
    
    // MARK: - Helper Computed Properties
    /// Determines whether the save button should be disabled.
    private var isSaveDisabled: Bool {
        wordItem.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wordItem.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        selectedDictionary == nil
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
