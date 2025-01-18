import SwiftUI

struct DictionaryRemoteDetailsViewCategory: View {
    let dictionary: DictionaryItemModel
    private let locale: DictionaryRemoteDetailsLocale
    private let style: DictionaryRemoteDetailsStyle
    
    init(
        dictionary: DictionaryItemModel,
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
                title: locale.categoryTitle.capitalizedFirstLetter,
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            .padding(.top, 8)
            
            VStack(spacing: style.spacing) {
                InputText(
                    text: .constant(dictionary.category),
                    placeholder: locale.categoryTitle,
                    isEditing: false
                )
                
                InputText(
                    text: .constant(dictionary.subcategory),
                    placeholder: locale.subcategoryTitle,
                    isEditing: false
                )
            }
            .padding(.horizontal, 8)
            .background(Color.clear)
        }
    }
}
