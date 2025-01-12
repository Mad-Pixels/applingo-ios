import SwiftUI

struct DictionaryDetailMainSection: View {
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
       Section(header: Text(locale.dictionaryTitle)) {
           InputText(
               text: .constant(dictionary.displayName),
               placeholder: locale.displayNameTitle,
               isEditing: false,
               icon: "book"
           )
           
           InputTextArea(
               text: .constant(dictionary.description),
               placeholder: locale.descriptionTitle,
               isEditing: false,
               icon: "scroll"
           )
           .frame(height: 150)
       }
   }
}
