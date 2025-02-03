import SwiftUI

// MARK: - DonutChartPreview
/// Preview provider for the DonutChart component.
struct DonutChartPreview: PreviewProvider {
    static var previews: some View {
        // Sample data for the donut chart
        let sampleData = [
            DonutChartModel(value: 3, label: "A", color: .red),
            DonutChartModel(value: 1, label: "B", color: .blue)
        ]
        
        return Group {
            // Light theme preview
            DonutChart(
                data: sampleData,
                centerValue: "100",
                style: .themed(LightTheme())
            )
            .previewDisplayName("Donut Chart - Light")
            .preferredColorScheme(.light)
            .padding()
            
            // Dark theme preview
            DonutChart(
                data: sampleData,
                centerValue: "100",
                style: .themed(DarkTheme())
            )
            .previewDisplayName("Donut Chart - Dark")
            .preferredColorScheme(.dark)
            .padding()
        }
    }
}
