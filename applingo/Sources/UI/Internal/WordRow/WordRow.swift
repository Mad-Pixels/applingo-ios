import SwiftUI

struct WordRow: View {
   let frontText: String
   let backText: String
   let style: WordRowStyle
   let onTap: () -> Void
   
   init(
       frontText: String,
       backText: String,
       style: WordRowStyle = .themed(ThemeManager.shared.currentThemeStyle),
       onTap: @escaping () -> Void
   ) {
       self.frontText = frontText
       self.backText = backText
       self.style = style
       self.onTap = onTap
   }
   
   var body: some View {
       HStack {
           Text(frontText)
               .foregroundColor(style.frontTextColor)
               .font(style.frontTextFont)
               .frame(maxWidth: .infinity, alignment: .leading)
           
           ZStack {
               Capsule()
                   .fill(style.capsuleColor)
                   .frame(width: style.capsuleSize.width, height: style.capsuleSize.height)
               
               Image(systemName: "arrow.left.and.right")
                   .font(.system(size: style.arrowSize, weight: .medium))
                   .foregroundColor(style.arrowColor)
           }
           
           Text(backText)
               .font(style.backTextFont)
               .foregroundColor(style.backTextColor)
               .frame(maxWidth: .infinity, alignment: .trailing)
       }
       .contentShape(Rectangle())
       .onTapGesture(perform: onTap)
   }
}
