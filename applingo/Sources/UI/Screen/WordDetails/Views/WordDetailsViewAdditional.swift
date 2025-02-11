import SwiftUI

/// A view displaying the additional section of the word details,
/// including table name, hint, and description.
struct WordDetailsViewAdditional: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    
    @Binding var word: DatabaseModelWord
    let tableName: String
    let isEditing: Bool
    
    // MARK: - Initializer
    /// Initializes the additional details view.
    /// - Parameters:
    ///   - word: Binding to the word model.
    ///   - tableName: The name of the table associated with the word.
    ///   - locale: The localization object.
    ///   - style: The style configuration.
    ///   - isEditing: Flag indicating if the view is in editing mode.
    init(
        style: WordDetailsStyle,
        locale: WordDetailsLocale,
        word: Binding<DatabaseModelWord>,
        tableName: String,
        isEditing: Bool
    ) {
        self.tableName = tableName
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
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
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
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
