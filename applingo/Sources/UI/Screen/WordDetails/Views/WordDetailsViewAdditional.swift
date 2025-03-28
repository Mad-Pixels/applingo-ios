import SwiftUI

/// A view displaying the additional section of the word details,
/// including dictionary name, hint, and description.
struct WordDetailsViewAdditional: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    @ObservedObject private var wordsAction: WordAction
    @Binding private var word: DatabaseModelWord
    private let isEditing: Bool
    
    // MARK: - Initializer
    /// Initializes the additional details view.
    /// - Parameters:
    ///   - style: `WordDetailsStyle` style configuration.
    ///   - locale: `WordDetailsLocale` localization object.
    ///   - word: Binding to the word model.
    ///   - isEditing: Flag indicating if the view is in editing mode.
    ///   - wordsAction: `WordAction` object injected from the parent.
    init(
        style: WordDetailsStyle,
        locale: WordDetailsLocale,
        word: Binding<DatabaseModelWord>,
        isEditing: Bool,
        wordsAction: WordAction
    ) {
        self.wordsAction = wordsAction
        self.isEditing = isEditing
        self.locale = locale
        self.style = style
        self._word = word
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .block(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(wordsAction.dictionary(word)),
                    title: locale.screenDescriptionDictionary,
                    placeholder: "",
                    isEditing: false
                )
                
                InputText(
                    text: Binding(
                        get: { word.hint },
                        set: { word.hint = $0.isEmpty ? "" : $0 }
                    ),
                    title: locale.screenDescriptionHint,
                    placeholder: "",
                    isEditing: isEditing
                )
                
                InputTextArea(
                    text: Binding(
                        get: { word.description },
                        set: { word.description = $0.isEmpty ? "" : $0 }
                    ),
                    title: locale.screenDescriptionDescription,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
