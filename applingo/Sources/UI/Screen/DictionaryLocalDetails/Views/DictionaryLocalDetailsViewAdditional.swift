import SwiftUI

struct DictionaryLocalDetailsViewAdditional: View {
    let dictionary: EditableDictionaryWrapper
    private let locale: DictionaryLocalDetailsLocale
    private let style: DictionaryLocalDetailsStyle
    let isEditing: Bool
   
    init(
        dictionary: EditableDictionaryWrapper,
        locale: DictionaryLocalDetailsLocale,
        style: DictionaryLocalDetailsStyle,
        isEditing: Bool
    ) {
        self.dictionary = dictionary
        self.locale = locale
        self.style = style
        self.isEditing = isEditing
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
                    text: Binding(
                        get: { dictionary.dictionary.author },
                        set: { dictionary.dictionary.author = $0 }
                    ),
                    title: locale.authorTitle.capitalizedFirstLetter,
                    placeholder: locale.authorTitle,
                    isEditing: isEditing
                )
                   
                InputText(
                    text: .constant(dictionary.dictionary.date),
                    title: locale.createdAtTitle.capitalizedFirstLetter,
                    placeholder: locale.createdAtTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
