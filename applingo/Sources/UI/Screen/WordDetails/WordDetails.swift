import SwiftUI
import Foundation

/// A view that displays the details of a word and allows editing.
/// On saving, the updated word is persisted using WordAction and the parent view is refreshed.
struct WordDetails: View {
    
    // MARK: - Environment and State Objects
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var style: WordDetailsStyle
    @StateObject private var locale = WordDetailsLocale()
    @StateObject private var wordsAction = WordAction()
    @StateObject private var wrapper: WordWrapper
    
    /// Binding to control the presentation state of this view.
    //@Binding var isPresented: Bool
    /// Closure to refresh the parent view after updating the word.
    let refresh: () -> Void
    /// The original word model to restore if editing is cancelled.
    private let originalWord: DatabaseModelWord
    
    // MARK: - Local State
    
    @State private var isEditing = false
    @State private var isShowingAlert = false
    @State private var isPressedLeading = false
    @State private var isPressedTrailing = false
    @State private var errorMessage: String = ""
    
    // MARK: - Initializer
    
    /// Initializes the WordDetails view.
    /// - Parameters:
    ///   - word: The word model to display.
    ///   - isPresented: Binding to control view presentation.
    ///   - refresh: Closure executed after a successful update.
    ///   - style: Optional style; if nil, a themed style is applied.
    init(
        word: DatabaseModelWord,
        //isPresented: Binding<Bool>,
        refresh: @escaping () -> Void,
        style: WordDetailsStyle? = nil
    ) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
        _wrapper = StateObject(wrappedValue: WordWrapper(word: word))
        //_isPresented = isPresented
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
                        word: $wrapper.word,
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                    WordDetailsViewAdditional(
                        word: $wrapper.word,
                        tableName: wordsAction.dictionary(wrapper.word),
                        locale: locale,
                        style: style,
                        isEditing: isEditing
                    )
                    WordDetailsViewStatistic(
                        style: style,
                        locale: locale,
                        word: wrapper.word
                    )
                }
                .padding(style.padding)
            }
            .padding(.bottom, style.padding.bottom)
            .keyboardAdaptive()
            .background(style.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Leading toolbar item: back or cancel editing
                ToolbarItem(placement: .navigationBarLeading) {
                    ButtonNav(
                        style: isEditing ? .close(ThemeManager.shared.currentThemeStyle) : .back(ThemeManager.shared.currentThemeStyle),
                        onTap: {
                            if isEditing {
                                isEditing = false
                                wrapper.word = originalWord
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        },
                        isPressed: $isPressedLeading
                    )
                }
                // Trailing toolbar item: edit or save
                ToolbarItem(placement: .navigationBarTrailing) {
                    ButtonNav(
                        style: isEditing ? .save(ThemeManager.shared.currentThemeStyle) : .edit(ThemeManager.shared.currentThemeStyle),
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
        wrapper.word.frontText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        wrapper.word.backText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - Actions
    
    /// Updates the word using WordAction and refreshes the parent view.
    private func updateWord() {
        wordsAction.update(wrapper.word) { _ in
            isEditing = false
            presentationMode.wrappedValue.dismiss()
            refresh()
        }
    }
}
