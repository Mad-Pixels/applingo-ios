import SwiftUI

struct DictionaryLocalDetailsViewCategory: View {
   let dictionary: EditableDictionaryWrapper
   private let locale: DictionaryLocalDetailsLocale
   let isEditing: Bool
   
   init(
       dictionary: EditableDictionaryWrapper,
       locale: DictionaryLocalDetailsLocale,
       isEditing: Bool
   ) {
       self.dictionary = dictionary
       self.locale = locale
       self.isEditing = isEditing
   }
   
   var body: some View {
       Section(header: Text(locale.categoryTitle)) {
           InputText(
               text: Binding(
                   get: { dictionary.dictionary.category },
                   set: { dictionary.dictionary.category = $0 }
               ),
               placeholder: locale.categoryTitle,
               isEditing: isEditing,
               icon: "cube"
           )
           
           InputText(
               text: Binding(
                   get: { dictionary.dictionary.subcategory },
                   set: { dictionary.dictionary.subcategory = $0 }
               ),
               placeholder: locale.subcategoryTitle,
               isEditing: isEditing,
               icon: "square.3.layers.3d"
           )
       }
   }
}
