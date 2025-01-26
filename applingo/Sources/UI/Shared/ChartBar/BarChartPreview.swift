import SwiftUI

#Preview("Bar Chart") {
   BarChartPreview()
}

private struct BarChartPreview: View {
   var body: some View {
       ScrollView {
           VStack(spacing: 32) {
               previewSection("Light Theme", theme: LightTheme())
               previewSection("Dark Theme", theme: DarkTheme())
           }
           .padding()
       }
   }
   
   private func previewSection(_ title: String, theme: AppTheme) -> some View {
       VStack(alignment: .leading, spacing: 20) {
           Text(title)
               .font(.headline)
           
           ChartBar(
               title: "Sample Data",
               data: [
                ChartBarModel(value: 30, label: "A", color: theme.accentPrimary),
                ChartBarModel(value: 50, label: "B", color: theme.success),
                ChartBarModel(value: 20, label: "C", color: theme.warning)
               ],
               style: .themed(theme)
           )
           
           ChartBar(
               title: "Equal Values",
               data: [
                ChartBarModel(value: 33.33, label: "X", color: theme.accentPrimary),
                ChartBarModel(value: 33.33, label: "Y", color: theme.success),
                ChartBarModel(value: 33.33, label: "Z", color: theme.warning)
               ],
               style: .themed(theme)
           )
           
           ChartBar(
               title: "Empty Data",
               data: [],
               style: .themed(theme)
           )
       }
       .padding()
       .background(theme.backgroundPrimary)
   }
}
