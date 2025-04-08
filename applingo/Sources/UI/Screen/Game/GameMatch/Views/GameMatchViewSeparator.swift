import SwiftUI

struct TaperedLineShape: Shape {
    var centerWidth: CGFloat
    var edgeWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let steps = max(Int(rect.height), 1)
        var rightPoints: [CGPoint] = []
        var leftPoints: [CGPoint] = []
        
        for i in 0...steps {
            let y = CGFloat(i) / CGFloat(steps) * rect.height
            let factor = sin(.pi * y / rect.height)
            let widthAtY = edgeWidth + (centerWidth - edgeWidth) * factor
            let halfWidth = widthAtY / 2
            rightPoints.append(CGPoint(x: rect.midX + halfWidth, y: rect.minY + y))
            leftPoints.append(CGPoint(x: rect.midX - halfWidth, y: rect.minY + y))
        }
        
        if let firstPoint = rightPoints.first {
            path.move(to: firstPoint)
        }
        
        for point in rightPoints {
            path.addLine(to: point)
        }
        
        for point in leftPoints.reversed() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

internal struct GameMatchViewSeparator: View {
    var centerLineWidth: CGFloat = 4
    var edgeLineWidth: CGFloat = 1
    var heightRatio: CGFloat = 0.7

    var body: some View {
        GeometryReader { geometry in
            let lineHeight = geometry.size.height * heightRatio
            ZStack {
                DynamicPattern(
                    model: ThemeManager.shared.currentThemeStyle.mainPattern,
                    size: CGSize(width: centerLineWidth * 2, height: lineHeight * 2)
                )
                .mask(
                    TaperedLineShape(centerWidth: centerLineWidth, edgeWidth: edgeLineWidth)
                        .frame(width: centerLineWidth, height: lineHeight)
                )
            }
            .frame(width: centerLineWidth, height: lineHeight)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(width: centerLineWidth)
    }
}
