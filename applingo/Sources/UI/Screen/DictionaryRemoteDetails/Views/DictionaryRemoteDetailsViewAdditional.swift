import SwiftUI

struct DictionaryRemoteDetailsViewAdditional: View {
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
        Section(header: Text(locale.additionalTitle)) {
            InputText(
                text: .constant(dictionary.author),
                placeholder: locale.authorTitle,
                isEditing: false,
                icon: "person"
            )
            
            InputText(
                text: .constant(dictionary.formattedCreatedAt),
                placeholder: locale.createdAtTitle,
                isEditing: false
            )
        }
    }
}
