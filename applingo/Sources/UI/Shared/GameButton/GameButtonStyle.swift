import SwiftUI

struct GameButtonStyle {
   let backgroundColor: Color
   let foregroundColor: Color
   let iconColor: Color
   let font: Font
   let iconSize: CGFloat
   let iconRotation: Double
   let padding: EdgeInsets
   let height: CGFloat
   let cornerRadius: CGFloat
}

extension GameButtonStyle {
   static func themed(_ theme: AppTheme, color: Color) -> GameButtonStyle {
       GameButtonStyle(
           backgroundColor: theme.backgroundPrimary,
           foregroundColor: theme.textPrimary,
           iconColor: color.opacity(0.7),
           font: .body.bold(),
           iconSize: 75,
           iconRotation: 45,
           padding: EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20),
           height: 70,
           cornerRadius: 12
       )
   }
}
