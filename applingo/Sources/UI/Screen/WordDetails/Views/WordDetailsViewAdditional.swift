import SwiftUI

/// A view displaying the additional section of the word details,
/// including table name, hint, and description.
struct WordDetailsViewAdditional: View {
    
    // MARK: - Bindings and Properties
    
    @Binding var word: DatabaseModelWord
    let tableName: String
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    /// Flag indicating whether editing is enabled.
    let isEditing: Bool
    
    // MARK: - Initializer
    
    /// Initializes the additional details view.
    /// - Parameters:
    ///   - word: Binding to the word model.
    ///   - tableName: The name of the table associated with the word.
    ///   - locale: Localization object.
    ///   - style: Style configuration.
    ///   - isEditing: Flag indicating if the view is in editing mode.
    init(
        word: Binding<DatabaseModelWord>,
        tableName: String,
        locale: WordDetailsLocale,
        style: WordDetailsStyle,
        isEditing: Bool
    ) {
        self._word = word
        self.tableName = tableName
        self.locale = locale
        self.style = style
        self.isEditing = isEditing
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(tableName),
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
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
