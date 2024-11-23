import SwiftUI

struct BarData: Identifiable {
    let id = UUID()
    let value: Double
    let label: String
    let color: Color
}

struct CompBarChartView: View {
    let title: String
    let barData: [BarData]
    var height: CGFloat = 160

    var totalValue: Double {
        barData.map { $0.value }.reduce(0, +)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 2)

            HStack(alignment: .bottom, spacing: 20) {
                ForEach(barData) { data in
                    BarView(data: data, maxHeight: height, totalValue: totalValue)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: height)
        }
    }
}

struct BarView: View {
    let data: BarData
    var maxHeight: CGFloat
    var totalValue: Double

    var proportionalHeight: CGFloat {
        guard totalValue > 0 else { return 0 }
        return CGFloat(data.value / totalValue) * (maxHeight - 40)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(data.color.opacity(0.2))
                    .cornerRadius(10)
                    .shadow(color: data.color.opacity(0.3), radius: 4, x: 0, y: 4)

                Rectangle()
                    .fill(data.color)
                    .cornerRadius(10)
                    .frame(height: proportionalHeight)
                    .shadow(color: data.color.opacity(0.5), radius: 6, x: 0, y: 6)
                    .animation(.easeInOut(duration: 0.5), value: data.value)
            }
            .frame(height: maxHeight - 40)

            Text("\(Int(data.value))")
                .font(.headline)
        }
    }
}
