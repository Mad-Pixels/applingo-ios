import SwiftUI

/// A view that displays the additional section for adding a word.
/// This section includes inputs for hint and description.
struct WordAddManualViewAdditional: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    @Binding var description: String
    @Binding var hint: String
    
    // MARK: - Initializer
    /// Initializes the additional view.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    ///   - hint: Binding for the hint text.
    ///   - description: Binding for the description text.
    init(
        style: WordAddManualStyle,
        locale: WordAddManualLocale,
        hint: Binding<String>,
        description: Binding<String>
    ) {
        self._description = description
        self._hint = hint
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .titled(themeManager.currentThemeStyle)
            )
            .padding(.top, style.paddingBlock)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: $hint,
                    title: locale.screenDescriptionHint,
                    placeholder: "",
                    isEditing: true
                )

                InputTextArea(
                    text: $description,
                    title: locale.screenDescriptionDescription,
                    placeholder: "",
                    isEditing: true
                )
            }
            .padding(.horizontal, style.paddingBlock)
            .background(Color.clear)
        }
    }
}
