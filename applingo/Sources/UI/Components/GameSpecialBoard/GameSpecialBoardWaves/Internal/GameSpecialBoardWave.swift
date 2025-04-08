import SwiftUI

internal struct GameSpecialBoardWave: Shape {
    internal var frequency: Double
    internal var amplitude: Double
    internal var phase: Double
    
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midHeight = height / 2
        
        let wavelength = width / frequency
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let angle = 2 * .pi * (x / wavelength)
            let y = sin(angle + phase) * amplitude * midHeight + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return Path(path.cgPath)
    }
}
