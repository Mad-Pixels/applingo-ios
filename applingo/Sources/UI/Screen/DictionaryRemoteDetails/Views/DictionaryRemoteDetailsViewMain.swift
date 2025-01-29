import SwiftUI

struct DictionaryRemoteDetailsViewMain: View {
    let dictionary: ApiModelDictionaryItem
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
   
    init(
        dictionary: ApiModelDictionaryItem,
        locale: DictionaryRemoteDetailsLocale,
        style: DictionaryRemoteDetailsStyle
    ) {
        self.dictionary = dictionary
        self.locale = locale
        self.style = style
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
                    text: .constant(dictionary.name),
                    placeholder: locale.displayNameTitle,
                    isEditing: false
                )
                   
                InputTextArea(
                    text: .constant(dictionary.description),
                    placeholder: locale.descriptionTitle,
                    isEditing: false
                )
                
                InputText(
                    text: .constant(dictionary.topic),
                    placeholder: locale.displayNameTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
