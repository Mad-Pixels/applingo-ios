import SwiftUI

#Preview("Dictionary Filter Screen") {
   NavigationView {
       DictionaryRemoteFilter(
           apiRequestParams: .constant(ApiModelDictionaryQueryRequest())
       )
   }
   .environmentObject(ThemeManager.shared)
   .environmentObject(LocaleManager.shared)
}

struct DictionaryRemoteFilterPreview_Previews: PreviewProvider {
   static var previews: some View {
       let categoryGetter = CategoryFetcher()
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
               DictionaryRemoteFilter(
                   apiRequestParams: .constant(ApiModelDictionaryQueryRequest())
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.light)
           
           // Dark theme
           NavigationView {
               DictionaryRemoteFilter(
                   apiRequestParams: .constant(ApiModelDictionaryQueryRequest())
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
           .preferredColorScheme(.dark)
           
           // Loading state
           NavigationView {
               DictionaryRemoteFilter(
                   apiRequestParams: .constant(ApiModelDictionaryQueryRequest())
               )
           }
           .environmentObject(ThemeManager.shared)
           .environmentObject(LocaleManager.shared)
       }
   }
}
