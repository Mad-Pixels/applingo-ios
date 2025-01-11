import SwiftUI

struct BarChart: View {
   let title: String
   let data: [BarData]
   let height: CGFloat
   let style: BarChartStyle
   
   init(
       title: String,
       data: [BarData],
       height: CGFloat = 160,
       style: BarChartStyle = .themed(ThemeManager.shared.currentThemeStyle)
   ) {
       self.title = title
       self.data = data
       self.height = height
       self.style = style
   }
   
   private var totalValue: Double {
       data.map { $0.value }.reduce(0, +)
   }
   
   var body: some View {
       VStack(alignment: .center, spacing: style.spacing) {
           Text(title)
               .font(style.titleFont)
               .foregroundColor(style.titleColor)
               .multilineTextAlignment(.center)
               .frame(maxWidth: .infinity)
               .padding(style.padding)
           
           HStack(alignment: .bottom, spacing: style.barSpacing) {
               ForEach(data) { item in
                   BarItem(
                       data: item,
                       maxHeight: height,
                       totalValue: totalValue,
                       style: style
                   )
                   .frame(maxWidth: .infinity)
               }
           }
           .frame(height: height)
       }
   }
}
