import SwiftUI

struct DictionaryLocalDetailsViewCategory: View {
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
                title: locale.categoryTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
           
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.category },
                        set: { dictionary.dictionary.category = $0 }
                    ),
                    title: locale.categoryTitle.capitalizedFirstLetter,
                    placeholder: locale.categoryTitle,
                    isEditing: isEditing
                )
                   
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.subcategory },
                        set: { dictionary.dictionary.subcategory = $0 }
                    ),
                    title: locale.subcategoryTitle.capitalizedFirstLetter,
                    placeholder: locale.subcategoryTitle,
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
