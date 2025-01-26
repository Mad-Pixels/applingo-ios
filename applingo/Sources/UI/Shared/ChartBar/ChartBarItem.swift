import SwiftUI

struct ChartBarItem: View {
   let data: ChartBarModel
   let maxHeight: CGFloat
   let totalValue: Double
   let style: ChartBarStyle
   
   private var proportionalHeight: CGFloat {
       guard totalValue > 0 else { return 0 }
       return CGFloat(data.value / totalValue) * (maxHeight - 40)
   }
   
   var body: some View {
       VStack {
           ZStack(alignment: .bottom) {
               Rectangle()
                   .fill(data.color.opacity(style.barBackgroundOpacity))
                   .cornerRadius(style.barCornerRadius)
                   .shadow(
                       color: data.color.opacity(style.barShadowOpacity),
                       radius: 4,
                       x: 0,
                       y: 4
                   )
               
               Rectangle()
                   .fill(data.color)
                   .cornerRadius(style.barCornerRadius)
                   .frame(height: proportionalHeight)
                   .shadow(
                       color: data.color.opacity(style.barShadowOpacity * 1.6),
                       radius: 6,
                       x: 0,
                       y: 6
                   )
                   .animation(
                       .easeInOut(duration: style.animationDuration),
                       value: data.value
                   )
           }
           .frame(height: maxHeight - 40)
           
           Text("\(Int(data.value))")
               .font(style.valueFont)
               .foregroundColor(style.valueColor)
       }
   }
}
