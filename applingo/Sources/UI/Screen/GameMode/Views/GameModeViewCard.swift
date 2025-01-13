import SwiftUI

struct GameModeViewCard: View {
   let mode: GameModeEnum
   let icon: String
   let title: String
   let description: String
   let style: GameModeStyle
   let isSelected: Bool
   let onSelect: () -> Void
   @EnvironmentObject private var themeManager: ThemeManager
   
   var body: some View {
       Button(action: onSelect) {
           HStack(spacing: style.cardSpacing) {
               Image(systemName: icon)
                   .font(.system(size: style.iconSize, weight: .bold))
                   .foregroundColor(.white)
                   .frame(width: 56, height: 56)
                   .background(
                       Circle()
                           .fill(themeManager.currentThemeStyle.accentPrimary)
                   )
               
               VStack(alignment: .leading, spacing: 4) {
                   Text(title)
                       .font(style.cardTitleStyle.font)
                       .foregroundColor(style.cardTitleStyle.color)
                   
                   Text(description)
                       .font(style.descriptionStyle.font)
                       .foregroundColor(style.descriptionStyle.color)
                       .lineLimit(2)
               }
               
               Spacer()
               
               Image(systemName: "chevron.right")
                   .font(.system(.body, weight: .semibold))
                   .foregroundColor(themeManager.currentThemeStyle.cardBorder)
                   .opacity(isSelected ? 1 : 0.5)
           }
           .padding()
           .background(
               RoundedRectangle(cornerRadius: style.cardCornerRadius)
                   .fill(themeManager.currentThemeStyle.cardBorder)
                   .shadow(
                       color: themeManager.currentThemeStyle.accentPrimary.opacity(0.2),
                       radius: isSelected ? 10 : 5,
                       x: 0,
                       y: isSelected ? 5 : 2
                   )
           )
           .scaleEffect(isSelected ? 1.02 : 1)
       }
   }
}
