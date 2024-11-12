import SwiftUI

struct CompProgressChartView: View {
    let value: Int
    let title: String
    let color: Color
    var height: CGFloat = 15
    let centerValue: Int = 5
    let maxValue: Int = 10

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
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .cornerRadius(10)

                        Rectangle()
                            .fill(color)
                            .cornerRadius(10)
                            .frame(width: calculateWidth(for: geometry.size.width))
                            .offset(x: calculateOffset(for: geometry.size.width))
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

            Text("\(centeredValue)")
                .multilineTextAlignment(.center)
                .foregroundColor(color)
                .font(.subheadline)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
    }

    private var centeredValue: Int {
        return value - centerValue
    }

    private func calculateWidth(for totalWidth: CGFloat) -> CGFloat {
        let range = CGFloat(maxValue - centerValue)
        let deviation = CGFloat(abs(value - centerValue))
        return totalWidth * (deviation / range) / 2
    }

    private func calculateOffset(for totalWidth: CGFloat) -> CGFloat {
        let range = CGFloat(maxValue - centerValue)
        let direction: CGFloat = value < centerValue ? -1 : 1
        let deviation = CGFloat(abs(value - centerValue))
        return direction * (totalWidth / 4) * (deviation / range)
    }
}
