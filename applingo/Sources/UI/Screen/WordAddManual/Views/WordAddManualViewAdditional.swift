import SwiftUI

internal struct WordAddManualViewAdditional: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Binding var description: String
    @Binding var hint: String
    
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
    /// Initializes the WordAddManualViewAdditional.
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
        self.locale = locale
        self.style = style
        
        self._hint = hint
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.screenSubtitleAdditional,
                style: .block(themeManager.currentThemeStyle)
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
