import SwiftUI

struct WordRowStyle {
   let frontTextColor: Color
   let backTextColor: Color
   let arrowColor: Color
   let capsuleColor: Color
   let frontTextFont: Font
   let backTextFont: Font
   let arrowSize: CGFloat
   let capsuleSize: CGSize
}

extension WordRowStyle {
   static func themed(_ theme: AppTheme) -> WordRowStyle {
       WordRowStyle(
           frontTextColor: theme.textPrimary,
           backTextColor: theme.textSecondary,
           arrowColor: theme.accentPrimary,
           capsuleColor: theme.accentPrimary.opacity(0.1),
           frontTextFont: .body,
           backTextFont: .subheadline,
           arrowSize: 12,
           capsuleSize: CGSize(width: 36, height: 24)
       )
   }
}
