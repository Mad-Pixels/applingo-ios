import SwiftUI

#Preview("Dictionary Detail Screen") {
   NavigationView {
       DictionaryRemoteDetails(
           dictionary: DictionaryItemModel(
            uuid: "en_basic",
               name: "English Basic",
               tableName: "en_basic",
               description: "Basic English vocabulary for beginners",
               category: "Language",
               subcategory: "English",
               author: "John Doe",
               id: 1
           ),
           isPresented: .constant(true)
       )
   }
   .environmentObject(ThemeManager.shared)
   .environmentObject(LocaleManager.shared)
}

struct ScreenDictionaryDetail_Previews: PreviewProvider {
   static var previews: some View {
       let mockDictionary = DictionaryItemModel(
        uuid: "en_basic",
           name: "English Basic",
           tableName: "en_basic",
           description: "Basic English vocabulary for beginners",
           category: "Language",
           subcategory: "English",
           author: "John Doe",
           id: 1
       )
       
       Group {
           // Light theme
           NavigationView {
               DictionaryRemoteDetails(
                   dictionary: mockDictionary,
                   isPresented: .constant(true)
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.light)
           
           // Dark theme
           NavigationView {
               DictionaryRemoteDetails(
                   dictionary: mockDictionary,
                   isPresented: .constant(true)
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.dark)
       }
   }
}
