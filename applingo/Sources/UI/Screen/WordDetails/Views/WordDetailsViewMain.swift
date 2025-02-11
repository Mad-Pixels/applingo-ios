import SwiftUI

/// A view displaying the main section of the word details,
/// including input fields for the front and back text.
struct WordDetailsViewMain: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
        
    @Binding var word: DatabaseModelWord
    let isEditing: Bool

    // MARK: - Initializer
    /// Initializes the main details view.
    /// - Parameters:
    ///   - word: Binding to the word model.
    ///   - locale: Localization object.
    ///   - style: Style configuration.
    ///   - isEditing: Flag for editing mode.
    init(
        style: WordDetailsStyle,
        locale: WordDetailsLocale,
        word: Binding<DatabaseModelWord>,
        isEditing: Bool
    ) {
        self.isEditing = isEditing
        self.locale = locale
        self.style = style
        self._word = word
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleWord,
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)

            VStack(spacing: style.spacing) {
                InputText(
                    text: $word.frontText,
                    title: locale.screenDescriptionFrontText,
                    placeholder: "",
                    isEditing: isEditing
                )

                InputText(
                    text: $word.backText,
                    title: locale.screenDescriptionBackText,
                    placeholder: "",
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
