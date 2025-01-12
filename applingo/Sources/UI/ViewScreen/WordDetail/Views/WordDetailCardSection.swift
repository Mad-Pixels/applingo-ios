import SwiftUI

struct WordDetailCardSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var word: WordItemModel
    private let locale: ScreenWordDetailLocale
    private let style: ScreenWordDetailStyle
    let isEditing: Bool
    
    init(
        word: Binding<WordItemModel>,
        locale: ScreenWordDetailLocale,
        style: ScreenWordDetailStyle,
        isEditing: Bool
    ) {
        self._word = word
        self.locale = locale
        self.style = style
        self.isEditing = isEditing
    }
    
    var body: some View {
        Section(header: Text(locale.cardTitle)) {
            VStack(spacing: style.spacing) {
                InputText(
                    text: $word.frontText,
                    placeholder: locale.wordPlaceholder,
                    isEditing: isEditing,
                    icon: "rectangle.and.pencil.and.ellipsis"
                )
                
                InputText(
                    text: $word.backText,
                    placeholder: locale.definitionPlaceholder,
                    isEditing: isEditing,
                    icon: "translate"
                )
            }
            .padding(style.padding)
        }
    }
}
