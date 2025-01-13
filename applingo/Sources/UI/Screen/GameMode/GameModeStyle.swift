import SwiftUI

final class GameModeStyle: ObservableObject {
   let backgroundColor: Color
   let padding: EdgeInsets
   let spacing: CGFloat
   let cardSpacing: CGFloat
   let iconSize: CGFloat
   let cardCornerRadius: CGFloat
   let titleStyle: TextStyle
   let cardTitleStyle: TextStyle
   let descriptionStyle: TextStyle
   
   struct TextStyle {
       let font: Font
       let color: Color
   }
   
   init(
       backgroundColor: Color,
       padding: EdgeInsets,
       spacing: CGFloat,
       cardSpacing: CGFloat,
       iconSize: CGFloat,
       cardCornerRadius: CGFloat,
       titleStyle: TextStyle,
       cardTitleStyle: TextStyle,
       descriptionStyle: TextStyle
   ) {
       self.backgroundColor = backgroundColor
       self.padding = padding
       self.spacing = spacing
       self.cardSpacing = cardSpacing
       self.iconSize = iconSize
       self.cardCornerRadius = cardCornerRadius
       self.titleStyle = titleStyle
       self.cardTitleStyle = cardTitleStyle
       self.descriptionStyle = descriptionStyle
   }
}

extension GameModeStyle {
   static func themed(_ theme: AppTheme) -> GameModeStyle {
       GameModeStyle(
           backgroundColor: theme.backgroundPrimary,
           padding: EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16),
           spacing: 32,
           cardSpacing: 20,
           iconSize: 24,
           cardCornerRadius: 16,
           titleStyle: TextStyle(
               font: .system(.title, design: .rounded).weight(.bold),
               color: theme.textPrimary
           ),
           cardTitleStyle: TextStyle(
               font: .system(.headline, design: .rounded).weight(.bold),
               color: theme.textPrimary
           ),
           descriptionStyle: TextStyle(
               font: .system(.body, design: .rounded),
               color: theme.textSecondary
           )
       )
   }
}
