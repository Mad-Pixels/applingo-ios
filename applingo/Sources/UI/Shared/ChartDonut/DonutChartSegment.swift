//import SwiftUI
//
///// Draws a single segment of the donut chart with a glowing overlay.
///// If the puzzle effect is enabled, a round bump is overlaid at the outer arc’s end.
//struct DonutChartSegment: View {
//    let segment: DonutChartModel
//    let startAngle: Double  // in degrees
//    let endAngle: Double    // in degrees
//    let style: DonutChartStyle
//    let isSelected: Bool
//
//    var body: some View {
//        GeometryReader { geometry in
//            let rect = geometry.frame(in: .local)
//            let center = CGPoint(x: rect.midX, y: rect.midY)
//            let outerRadius = min(rect.width, rect.height) / 2
//            let innerRadius = outerRadius - style.lineWidth
//            
//            // Build the basic donut segment path.
//            var path = Path()
//            path.addArc(
//                center: center,
//                radius: outerRadius,
//                startAngle: .degrees(startAngle),
//                endAngle: .degrees(endAngle),
//                clockwise: false
//            )
//            path.addArc(
//                center: center,
//                radius: innerRadius,
//                startAngle: .degrees(endAngle),
//                endAngle: .degrees(startAngle),
//                clockwise: true
//            )
//            path.closeSubpath()
//            
//            return path
//                .fill(segment.color)
//                .scaleEffect(isSelected ? 1.05 : 1.0)
//                .shadow(color: .black.opacity(isSelected ? 0.3 : 0.1),
//                        radius: isSelected ? 5 : 2,
//                        x: 0,
//                        y: isSelected ? 5 : 2)
//                .animation(.easeInOut(duration: style.animationDuration), value: isSelected)
//        }
//    
//
//    }
//    
//    /// Computes the point on a circle for a given center, radius, and angle (in degrees).
//    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
//        let rad = Angle(degrees: angle).radians
//        return CGPoint(x: center.x + radius * cos(CGFloat(rad)),
//                       y: center.y + radius * sin(CGFloat(rad)))
//    }
//}
