import SwiftUI

struct ChartIndicator: View {
    let weight: Int
    let style: WordRowStyle
    
    private var progress: CGFloat {
        CGFloat(weight) / 1000.0
    }
    
    private var indicatorColor: Color {
        if weight < 300 {
            return .red.opacity(0.7)
        } else if weight < 700 {
            return .orange.opacity(0.7)
        } else {
            return .green.opacity(0.7)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    //.fill(style.capsuleColor)
                    .frame(width: geometry.size.width, height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(indicatorColor)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .cornerRadius(2)
                    .animation(.spring(response: 0.3), value: weight)
            }
        }
        .frame(height: 4)
    }
}
