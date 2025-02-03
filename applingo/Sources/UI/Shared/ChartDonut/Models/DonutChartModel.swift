import SwiftUI

// MARK: - DonutChartModel
/// Model representing a segment of the donut chart.
struct DonutChartModel: Identifiable {
    let id = UUID()
    let value: Double
    let label: String
    let color: Color
}
