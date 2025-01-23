import SwiftUI

struct DictionaryRemoteDetailsViewAdditional: View {
    let dictionary: DatabaseModelDictionary
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    init(
        dictionary: DatabaseModelDictionary,
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
                title: locale.additionalTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(dictionary.author),
                    placeholder: locale.authorTitle,
                    isEditing: false
                )
                
                InputText(
                    text: .constant(dictionary.date),
                    placeholder: locale.createdAtTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
