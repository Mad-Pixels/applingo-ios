import SwiftUI

final class DictionaryRemoteDetailsStyle: ObservableObject {
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

extension DictionaryRemoteDetailsStyle {
   static func themed(_ theme: AppTheme) -> DictionaryRemoteDetailsStyle {
       DictionaryRemoteDetailsStyle(
           backgroundColor: theme.backgroundPrimary,
           padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
           spacing: 16
       )
   }
}
