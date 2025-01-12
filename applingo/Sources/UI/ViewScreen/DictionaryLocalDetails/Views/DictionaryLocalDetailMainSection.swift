import SwiftUI

struct DictionaryLocalDetailMainSection: View {
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
       Section(header: Text(locale.dictionaryTitle)) {
           InputText(
               text: Binding(
                   get: { dictionary.dictionary.displayName },
                   set: { dictionary.dictionary.displayName = $0 }
               ),
               placeholder: locale.displayNameTitle,
               isEditing: isEditing,
               icon: "book"
           )
           
           InputTextArea(
               text: Binding(
                   get: { dictionary.dictionary.description },
                   set: { dictionary.dictionary.description = $0 }
               ),
               placeholder: locale.descriptionTitle,
               isEditing: isEditing,
               icon: "scroll"
           )
           .frame(height: 150)
       }
   }
}
