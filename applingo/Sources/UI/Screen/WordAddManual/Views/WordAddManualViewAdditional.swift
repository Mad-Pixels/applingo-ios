import SwiftUI

struct WordAddManualViewAdditional: View {
    @Binding var hint: String
    @Binding var description: String
    private let locale: WordAddManualLocale
    private let style: WordAddManualStyle
    
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
    
    var body: some View {
        VStack(spacing: style.spacing) {
            SectionHeader(
                title: locale.additionalTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: $hint,
                    title: locale.hintPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.hintPlaceholder,
                    isEditing: true
                )
                
                InputTextArea(
                    text: $description,
                    title: locale.descriptionPlaceholder.capitalizedFirstLetter,
                    placeholder: locale.descriptionPlaceholder,
                    isEditing: true
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
