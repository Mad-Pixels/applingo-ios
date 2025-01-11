import SwiftUI

struct BarChartStyle {
   let titleFont: Font
   let valueFont: Font
   let titleColor: Color
   let valueColor: Color
   let spacing: CGFloat
   let barSpacing: CGFloat
   let barCornerRadius: CGFloat
   let barBackgroundOpacity: Double
   let barShadowOpacity: Double
   let padding: EdgeInsets
   let animationDuration: Double
}

extension BarChartStyle {
   static func themed(_ theme: AppTheme) -> BarChartStyle {
       BarChartStyle(
           titleFont: .headline,
           valueFont: .headline,
           titleColor: theme.textPrimary,
           valueColor: theme.textPrimary,
           spacing: 16,
           barSpacing: 20,
           barCornerRadius: 10,
           barBackgroundOpacity: 0.2,
           barShadowOpacity: 0.3,
           padding: EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0),
           animationDuration: 0.5
       )
   }
}
