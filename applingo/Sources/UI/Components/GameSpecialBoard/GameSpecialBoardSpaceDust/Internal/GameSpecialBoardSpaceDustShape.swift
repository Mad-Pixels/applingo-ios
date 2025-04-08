import SwiftUI

struct GameSpecialBoardSpaceDustShape: Shape {
    let points: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        for i in 0..<points {
            let angle = Double.random(in: 0...2 * .pi)
            let distance = CGFloat.random(in: 0...rect.width / 2)
            
            let x = center.x + cos(angle) * distance
            let y = center.y + sin(angle) * distance
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}
