import SwiftUI

struct DictionaryDetailCategorySection: View {
    let dictionary: DictionaryItemModel
    private let locale: ScreenDictionaryDetailLocale
    
    init(
        dictionary: DictionaryItemModel,
        locale: ScreenDictionaryDetailLocale
    ) {
        self.dictionary = dictionary
        self.locale = locale
    }
    
    var body: some View {
        Section(header: Text(locale.categoryTitle)) {
            InputText(
                text: .constant(dictionary.category),
                placeholder: locale.categoryTitle,
                isEditing: false,
                icon: "cube"
            )
            
            InputText(
                text: .constant(dictionary.subcategory),
                placeholder: locale.subcategoryTitle,
                isEditing: false,
                icon: "square.3.layers.3d"
            )
        }
    }
}
