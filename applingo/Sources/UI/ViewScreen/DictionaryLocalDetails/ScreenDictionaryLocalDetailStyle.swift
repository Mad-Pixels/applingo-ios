import SwiftUI

final class ScreenDictionaryLocalDetailStyle: ObservableObject {
   let backgroundColor: Color
   let padding: EdgeInsets
   let spacing: CGFloat
   
   init(
       backgroundColor: Color,
       padding: EdgeInsets,
       spacing: CGFloat
   ) {
       self.backgroundColor = backgroundColor
       self.padding = padding
       self.spacing = spacing
   }
}


extension ScreenDictionaryLocalDetailStyle {
   static func themed(_ theme: AppTheme) -> ScreenDictionaryDetailStyle {
       ScreenDictionaryDetailStyle(
           backgroundColor: theme.backgroundPrimary,
           padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
           spacing: 16
       )
   }
}
