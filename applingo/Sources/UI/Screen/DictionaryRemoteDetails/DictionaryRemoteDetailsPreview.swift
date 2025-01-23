import SwiftUI

#Preview("Dictionary Detail Screen") {
   NavigationView {
       DictionaryRemoteDetails(
           dictionary: DatabaseModelDictionary(
            guid: "en_basic",
               name: "English Basic",
            author: "John Doe",
            category: "Language",
            subcategory: "English",
               description: "Basic English vocabulary for beginners",
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
       let mockDictionary = DatabaseModelDictionary(
        guid: "en_basic",
           name: "English Basic",
        author: "John Doe",
        category: "Language",
        subcategory: "English",
           description: "Basic English vocabulary for beginners",
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
