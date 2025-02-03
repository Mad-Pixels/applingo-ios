//
//  DonutChartPreview.swift
//  applingo
//
//  Created by Igor Chelyshkin on 03/02/2025.
//

import SwiftUI

// MARK: - DonutChartPreview
/// Preview provider for the DonutChart component.
struct DonutChartPreview: PreviewProvider {
    static var previews: some View {
        // Sample data for the donut chart
        let sampleData = [
            DonutChartModel(value: 40, label: "A", color: .red),
            DonutChartModel(value: 30, label: "B", color: .blue),
            DonutChartModel(value: 30, label: "C", color: .green)
        ]
        
        return Group {
            // Light theme preview
            DonutChart(data: sampleData, centerValue: "100")
                .previewDisplayName("Donut Chart - Light")
                .preferredColorScheme(.light)
                .padding()
            
            // Dark theme preview
            DonutChart(data: sampleData, centerValue: "100")
                .previewDisplayName("Donut Chart - Dark")
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
