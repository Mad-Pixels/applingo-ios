import SwiftUI

struct DictionaryLocalDetailsViewMain: View {
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
                title: locale.dictionaryTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
           
            VStack(spacing: style.spacing) {
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.name },
                        set: { dictionary.dictionary.name = $0 }
                    ),
                    title: locale.displayNameTitle.capitalizedFirstLetter,
                    placeholder: locale.displayNameTitle,
                    isEditing: isEditing
                )
                   
                InputTextArea(
                    text: Binding(
                        get: { dictionary.dictionary.description },
                        set: { dictionary.dictionary.description = $0 }
                    ),
                    title: locale.descriptionTitle.capitalizedFirstLetter,
                    placeholder: locale.descriptionTitle,
                    isEditing: isEditing
                )
                
                InputText(
                    text: Binding(
                        get: { dictionary.dictionary.topic },
                        set: { dictionary.dictionary.topic = $0 }
                    ),
                    title: locale.displayNameTitle.capitalizedFirstLetter,
                    placeholder: locale.displayNameTitle,
                    isEditing: isEditing
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
