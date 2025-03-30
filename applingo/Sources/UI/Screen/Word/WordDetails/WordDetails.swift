import SwiftUI

struct WordDetails: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var locale = WordDetailsLocale()
    @StateObject private var wordsAction = WordAction()
    @StateObject private var style: WordDetailsStyle
    
    @State private var isEditing = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
    @State private var editableWord: DatabaseModelWord
    
    private let originalWord: DatabaseModelWord
    private let refresh: () -> Void

    /// Initializes the WordDetails.
    /// - Parameters:
    ///   - word: The word model to display.
    ///   - refresh: Closure executed after a successful update.
    ///   - style: Optional style; if nil, a themed style is applied.
    init(
        word: DatabaseModelWord,
        refresh: @escaping () -> Void,
        style: WordDetailsStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
        _editableWord = State(initialValue: word)
        
        self.originalWord = word
        self.refresh = refresh
    }
    
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
                        word: $editableWord
                    )
                }
                .padding(style.padding)
            }
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .padding(.bottom, style.padding.bottom)
            .onAppear {
                wordsAction.setScreen(.WordDetails)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        isPressed: $isPressedLeading,
                        onTap: {
                            if isEditing {
                                isEditing = false
                                editableWord = originalWord
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        style: isEditing ?
                            .close(themeManager.currentThemeStyle) :
                            .back(themeManager.currentThemeStyle)
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        isPressed: $isPressedTrailing,
                        onTap: {
                            if isEditing {
                                updateWord()
                            } else {
                                isEditing = true
                            }
                        },
                        style: isEditing ?
                            .save(themeManager.currentThemeStyle, disabled: self.isSaveDisabled) :
                            .edit(themeManager.currentThemeStyle)
                    )
                    .disabled(isEditing && isSaveDisabled)
                }
            }
        }
    }
    
    /// Determines if the save button should be disabled.
    private var isSaveDisabled: Bool {
        editableWord.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        editableWord.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Updates the word using WordAction and refreshes the parent view.
    private func updateWord() {
        wordsAction.update(editableWord) { _ in
            presentationMode.wrappedValue.dismiss()
            isEditing = false
            refresh()
        }
    }
}
