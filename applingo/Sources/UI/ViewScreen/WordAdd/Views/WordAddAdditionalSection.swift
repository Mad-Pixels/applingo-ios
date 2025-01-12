import SwiftUI

struct WordAddAdditionalSection: View {
    @Binding var hint: String
    @Binding var description: String
    private let locale: ScreenWordAddLocale
    private let style: ScreenWordAddStyle
    
    init(
        hint: Binding<String>,
        description: Binding<String>,
        locale: ScreenWordAddLocale,
        style: ScreenWordAddStyle
    ) {
        self._hint = hint
        self._description = description
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        Section(header: Text(locale.additionalTitle)) {
            VStack(spacing: style.spacing) {
                InputText(
                    text: $hint,
                    placeholder: locale.hintPlaceholder,
                    icon: "tag"
                )
                
                InputTextArea(
                    text: $description,
                    placeholder: locale.descriptionPlaceholder,
                    icon: "scroll"
                )
            }
            .padding(style.padding)
        }
    }
}
