import SwiftUI

/// A view displaying the main section of the word details,
/// including input fields for the front and back text.
struct WordDetailsViewMain: View {
    
    // MARK: - Bindings and Properties
    
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var word: DatabaseModelWord
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    /// Flag indicating if editing is enabled.
    let isEditing: Bool
    
    // MARK: - Initializer
    
    /// Initializes the main details view.
    /// - Parameters:
    ///   - word: Binding to the word model.
    ///   - locale: Localization object.
    ///   - style: Style configuration.
    ///   - isEditing: Flag for editing mode.
    init(
        word: Binding<DatabaseModelWord>,
        locale: WordDetailsLocale,
        style: WordDetailsStyle,
        isEditing: Bool
    ) {
        self._word = word
        self.locale = locale
        self.style = style
        self.isEditing = isEditing
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.cardTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: $word.frontText,
                    title: locale.wordPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.wordPlaceholder,
                    isEditing: isEditing
                )
                InputText(
                    text: $word.backText,
                    title: locale.definitionPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.definitionPlaceholder,
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
