import SwiftUI

struct DictionaryRemoteDetailsCategory: View {
    let dictionary: DictionaryItemModel
    private let locale: DictionaryRemoteDetailsLocale
    
    init(
        dictionary: DictionaryItemModel,
        locale: DictionaryRemoteDetailsLocale
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
