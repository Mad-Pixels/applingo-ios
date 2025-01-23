import SwiftUI

#Preview("Dictionary Detail Screen") {
   NavigationView {
       DictionaryLocalDetails(
        dictionary: DictionaryItemModel(
            uuid: "en_basic",
               name: "English Basic",
               description: "Basic English vocabulary",
               category: "Language",
               subcategory: "English",
               author: "John Doe",
               id: 1
           ),
           isPresented: .constant(true),
           refresh: {}
       )
   }
   .environmentObject(ThemeManager.shared)
   .environmentObject(LocaleManager.shared)
}

struct ScreenDictionaryLocalDetail_Previews: PreviewProvider {
   static var previews: some View {
       let mockDictionary = DictionaryItemModel(
        uuid: "en_basic",
           name: "English Basic",
           description: "Basic English vocabulary",
           category: "Language",
           subcategory: "English",
           author: "John Doe",
           id: 2
       )
       
       Group {
           // Light theme
           NavigationView {
               DictionaryLocalDetails(
                   dictionary: mockDictionary,
                   isPresented: .constant(true),
                   refresh: {}
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.light)
           
           // Dark theme with editing
           NavigationView {
               DictionaryLocalDetails(
                   dictionary: mockDictionary,
                   isPresented: .constant(true),
                   refresh: {}
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.dark)
       }
   }
}
