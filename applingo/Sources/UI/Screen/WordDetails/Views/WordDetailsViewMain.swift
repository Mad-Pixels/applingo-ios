import SwiftUI

struct WordDetailsViewMain: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var word: DatabaseModelWord
    private let locale: WordDetailsLocale
    private let style: WordDetailsStyle
    let isEditing: Bool
    
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
