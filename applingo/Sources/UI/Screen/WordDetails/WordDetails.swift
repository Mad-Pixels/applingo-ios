import SwiftUI
import Foundation

/// A view that displays the details of a word and allows editing.
/// On saving, the updated word is persisted using WordAction and the parent view is refreshed.
struct WordDetails: View {
    // MARK: - Properties
    @Environment(\.presentationMode) private var presentationMode
    private let originalWord: DatabaseModelWord
    let refresh: () -> Void

    // MARK: - State Objects
    @StateObject private var style: WordDetailsStyle
    @StateObject private var locale = WordDetailsLocale()
    @StateObject private var wordsAction = WordAction()
    
    // MARK: - Local State
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
    @State private var errorMessage: String = ""
    @State private var editableWord: DatabaseModelWord
    
    // MARK: - Initializer
    /// Initializes the WordDetails view.
    /// - Parameters:
    ///   - word: The word model to display.
    ///   - refresh: Closure executed after a successful update.
    ///   - style: Optional style; if nil, a themed style is applied.
    init(
        word: DatabaseModelWord,
        refresh: @escaping () -> Void,
        style: WordDetailsStyle? = nil
    ) {
        _style = StateObject(wrappedValue: style ?? .themed(ThemeManager.shared.currentThemeStyle))
        _editableWord = State(initialValue: word)
        self.originalWord = word
        self.refresh = refresh
    }
    
    // MARK: - Body
    var body: some View {
        BaseScreen(
            screen: .WordDetails,
            title: locale.screenTitle
        ) {
            ScrollView {
                VStack(spacing: style.spacing) {
                    WordDetailsViewMain(
                        style: style,
                        locale: locale,
                        word: $editableWord,
                        isEditing: isEditing
                    )

                    WordDetailsViewAdditional(
                        style: style,
                        locale: locale,
                        word: $editableWord,
                        isEditing: isEditing,
                        wordsAction: wordsAction
                    )

                    WordDetailsViewStatistic(
                        style: style,
                        locale: locale,
                        word: editableWord
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .padding(.bottom, style.padding.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        style: isEditing ?
                            .close(ThemeManager.shared.currentThemeStyle) :
                            .back(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            if isEditing {
                                isEditing = false
                                editableWord = originalWord
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        isPressed: $isPressedLeading
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: isEditing ?
                            .save(ThemeManager.shared.currentThemeStyle, disabled: self.isSaveDisabled) :
                            .edit(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            if isEditing {
                                updateWord()
                            } else {
                                isEditing = true
                            }
                        },
                        isPressed: $isPressedTrailing
                    )
                    .disabled(isEditing && isSaveDisabled)
                }
            }
        }
    }
    
    // MARK: - Helper Computed Properties
    /// Determines if the save button should be disabled.
    private var isSaveDisabled: Bool {
        editableWord.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editableWord.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    /// Updates the word using WordAction and refreshes the parent view.
    private func updateWord() {
        wordsAction.update(editableWord) { _ in
            presentationMode.wrappedValue.dismiss()
            isEditing = false
            refresh()
        }
    }
}
