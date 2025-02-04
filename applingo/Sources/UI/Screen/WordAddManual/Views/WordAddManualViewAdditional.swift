import SwiftUI

/// A view that displays the additional section for adding a word.
/// This section includes inputs for hint and description.
struct WordAddManualViewAdditional: View {
    
    // MARK: - Bindings and Properties
    
    @Binding var hint: String
    @Binding var description: String
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    // MARK: - Initializer
    
    /// Initializes the additional view.
    /// - Parameters:
    ///   - hint: Binding for the hint text.
    ///   - description: Binding for the description text.
    ///   - locale: Localization object.
    ///   - style: Style configuration.
    init(
        hint: Binding<String>,
        description: Binding<String>,
        locale: WordAddManualLocale,
        style: WordAddManualStyle
    ) {
        self._hint = hint
        self._description = description
        self.locale = locale
        self.style = style
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
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
