import SwiftUI

struct CompProgressChartView: View {
    let value: Double
    let title: String
    let color: Color
    var height: CGFloat = 15
    let minValue: Double = -1000
    let maxValue: Double = 1000

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
                .font(.headline)

            HStack {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
                    .padding(.trailing, 4)

                GeometryReader { geometry in
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .cornerRadius(10)

                        Rectangle()
                            .fill(color)
                            .cornerRadius(10)
                            .frame(width: calculateWidth(for: geometry.size.width), alignment: value >= 0 ? .leading : .trailing)
                            .animation(.easeInOut(duration: 0.5), value: value)
                    }
                }
                .frame(height: height)
                .cornerRadius(10)

                Image(systemName: "plus.circle")
                    .foregroundColor(.green)
                    .padding(.leading, 4)
            }
            .frame(maxWidth: .infinity)

            Text(String(format: "%.2f", value))
                .multilineTextAlignment(.center)
                .foregroundColor(color)
                .font(.subheadline)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
    }

    private func calculateWidth(for totalWidth: CGFloat) -> CGFloat {
        let zeroPosition = totalWidth / 2
        let percentage = CGFloat(value) / CGFloat(maxValue - minValue)
        return zeroPosition * abs(percentage) * 2
    }
}
