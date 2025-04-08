import SwiftUI

struct GameSpecialBoardNebulaDustLayer: Shape {
    let pointCount: Int
    let sizeRange: ClosedRange<CGFloat>
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for _ in 0..<pointCount {
            let size = CGFloat.random(in: sizeRange)
            let x = CGFloat.random(in: 0...rect.width)
            let y = CGFloat.random(in: 0...rect.height)
            
            path.addEllipse(in: CGRect(x: x - size/2, y: y - size/2, width: size, height: size))
        }
        
        return path
    }
}
