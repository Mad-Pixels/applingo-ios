import SwiftUI

struct DictionaryLocalDetails: View {
   @Environment(\.presentationMode) private var presentationMode
   @StateObject private var style: DictionaryLocalDetailsStyle
   @StateObject private var locale = DictionaryLocalDetailsLocale()
   @StateObject private var dictionaryAction = DictionaryLocalActionViewModel()
   @StateObject private var wrapper: EditableDictionaryWrapper
   
   @State private var isEditing = false
   @Binding var isPresented: Bool
   let refresh: () -> Void
   private let originalDictionary: DictionaryItemModel
   
   init(
       dictionary: DictionaryItemModel,
       isPresented: Binding<Bool>,
       refresh: @escaping () -> Void,
       style: DictionaryLocalDetailsStyle? = nil
   ) {
       let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
       _style = StateObject(wrappedValue: initialStyle)
       _wrapper = StateObject(wrappedValue: EditableDictionaryWrapper(dictionary: dictionary))
       _isPresented = isPresented
       self.refresh = refresh
       self.originalDictionary = dictionary
   }
   
   var body: some View {
       BaseScreen(screen: .dictionariesLocalDetail, title: locale.navigationTitle) {
           Form {
               DictionaryLocalDetailsViewMain(
                   dictionary: wrapper,
                   locale: locale,
                   isEditing: isEditing
               )
               
               DictionaryLocalDetailsViewCategory(
                   dictionary: wrapper,
                   locale: locale,
                   isEditing: isEditing
               )
               
               DictionaryLocalDetailsViewAdditional(
                   dictionary: wrapper,
                   locale: locale,
                   isEditing: isEditing
               )
           }
           .navigationTitle(locale.navigationTitle)
           .navigationBarTitleDisplayMode(.inline)
           .navigationBarItems(
               leading: Button(isEditing ? locale.cancelTitle : locale.closeTitle) {
                   if isEditing {
                       isEditing = false
                       wrapper.dictionary = originalDictionary
                   } else {
                       presentationMode.wrappedValue.dismiss()
                   }
               },
               trailing: Button(isEditing ? locale.saveTitle : locale.editTitle) {
                   if isEditing {
                       updateDictionary()
                   } else {
                       isEditing = true
                   }
               }
               .disabled(isEditing && isSaveDisabled)
           )
       }
   }
   
   private var isSaveDisabled: Bool {
       wrapper.dictionary.displayName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
       wrapper.dictionary.category.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
       wrapper.dictionary.subcategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
       wrapper.dictionary.author.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty ||
       wrapper.dictionary.description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
   }
   
   private func updateDictionary() {
       dictionaryAction.update(wrapper.dictionary) { _ in
           self.isEditing = false
           self.presentationMode.wrappedValue.dismiss()
           refresh()
       }
   }
}
