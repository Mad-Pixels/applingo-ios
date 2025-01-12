import SwiftUI

#Preview("Dictionary Filter Screen") {
   NavigationView {
       ScreenDictionaryFilter(
           apiRequestParams: .constant(ApiDictionaryQueryRequestModel())
       )
   }
   .environmentObject(ThemeManager.shared)
   .environmentObject(LocaleManager.shared)
}

struct ScreenDictionaryFilter_Previews: PreviewProvider {
   static var previews: some View {
       let categoryGetter = CategoryRemoteGetterViewModel()
       categoryGetter.frontCategories = [
           CategoryItem(code: "EN"),
           CategoryItem(code: "ES"),
           CategoryItem(code: "FR")
       ]
       categoryGetter.backCategories = [
           CategoryItem(code: "RU"),
           CategoryItem(code: "DE"),
           CategoryItem(code: "IT")
       ]
       
       return Group {
           // Light theme
           NavigationView {
               ScreenDictionaryFilter(
                   apiRequestParams: .constant(ApiDictionaryQueryRequestModel())
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.light)
           
           // Dark theme
           NavigationView {
               ScreenDictionaryFilter(
                   apiRequestParams: .constant(ApiDictionaryQueryRequestModel())
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.dark)
           
           // Loading state
           NavigationView {
               ScreenDictionaryFilter(
                   apiRequestParams: .constant(ApiDictionaryQueryRequestModel())
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
       }
   }
}
