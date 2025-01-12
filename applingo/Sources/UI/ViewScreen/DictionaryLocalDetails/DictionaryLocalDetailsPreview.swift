import SwiftUI

#Preview("Dictionary Detail Screen") {
   NavigationView {
       DictionaryLocalDetails(
           dictionary: DictionaryItemModel(
               id: 1,
               key: "en_basic",
               displayName: "English Basic",
               tableName: "en_basic",
               description: "Basic English vocabulary",
               category: "Language",
               subcategory: "English",
               author: "John Doe"
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
           id: 1,
           key: "en_basic",
           displayName: "English Basic",
           tableName: "en_basic",
           description: "Basic English vocabulary",
           category: "Language",
           subcategory: "English",
           author: "John Doe"
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
