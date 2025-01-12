import SwiftUI

struct DictionaryLocalDetailAdditionalSection: View {
   let dictionary: EditableDictionaryWrapper
   private let locale: ScreenDictionaryLocalDetailLocale
   let isEditing: Bool
   
   init(
       dictionary: EditableDictionaryWrapper,
       locale: ScreenDictionaryLocalDetailLocale,
       isEditing: Bool
   ) {
       self.dictionary = dictionary
       self.locale = locale
       self.isEditing = isEditing
   }
   
   var body: some View {
       Section(header: Text(locale.additionalTitle)) {
           InputText(
               text: Binding(
                   get: { dictionary.dictionary.author },
                   set: { dictionary.dictionary.author = $0 }
               ),
               placeholder: locale.authorTitle,
               isEditing: isEditing,
               icon: "person"
           )
           
           InputText(
               text: .constant(dictionary.dictionary.formattedCreatedAt),
               placeholder: locale.createdAtTitle,
               isEditing: false
           )
       }
   }
}
