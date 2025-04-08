import SwiftUI

struct GameSpecialBoardNebulaStarLayer: Shape {
    let points: Int
    let irregularity: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var controlPoints: [CGPoint] = []
        
        for i in 0..<points {
            let angle = 2 * .pi * Double(i) / Double(points)
            let randomRadius = radius * (1 - irregularity + CGFloat.random(in: 0...irregularity * 2))
            let x = center.x + cos(angle) * randomRadius
            let y = center.y + sin(angle) * randomRadius
            controlPoints.append(CGPoint(x: x, y: y))
        }
        
        controlPoints.append(controlPoints[0])
        controlPoints.append(controlPoints[1])
        
        path.move(to: controlPoints[0])
        
        for i in 0..<points {
            let cp1 = CGPoint(
                x: (controlPoints[i].x + controlPoints[i+1].x) / 2,
                y: (controlPoints[i].y + controlPoints[i+1].y) / 2
            )
            let cp2 = CGPoint(
                x: (controlPoints[i+1].x + controlPoints[i+2].x) / 2,
                y: (controlPoints[i+1].y + controlPoints[i+2].y) / 2
            )
            
            path.addQuadCurve(to: cp2, control: controlPoints[i+1])
        }
        
        return path
    }
}
