import SwiftUI

struct DynamicPattern: View {
    let config: DynamicPatternConfig
    let model: DynamicPatternModel
    let size: CGSize
    
    init(
        model: DynamicPatternModel,
        size: CGSize,
        config: DynamicPatternConfig = .default
    ) {
        self.config = config
        self.model = model
        self.size = size
    }

    var body: some View {
        Canvas { context, _ in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(model.colors[0]))
            
            for i in 1..<model.colors.count {
                let mainPath = Path { path in
                    for _ in 0..<config.numberOfPaths {
                        let x = CGFloat.random(in: -20...size.width+20)
                        let y = CGFloat.random(in: -20...size.height+20)
                        var points: [CGPoint] = []
                        
                        for angle in stride(from: 0, to: 360, by: 20) {
                            let radian = Double(angle) * .pi / 180
                            let radius = CGFloat.random(in: config.minRadius...config.maxRadius)
                            let px = x + cos(radian) * radius * CGFloat.random(in: 0.7...1.3)
                            let py = y + sin(radian) * radius * CGFloat.random(in: 0.7...1.3)
                            points.append(CGPoint(x: px, y: py))
                        }
                        
                        path.move(to: points[0])
                        for i in 0..<points.count {
                            let control = CGPoint(
                                x: points[i].x + CGFloat.random(in: -20...20),
                                y: points[i].y + CGFloat.random(in: -20...20)
                            )
                            path.addQuadCurve(
                                to: points[(i + 1) % points.count],
                                control: control
                            )
                        }
                    }
                }
                
                context.blendMode = .normal
                context.opacity = 0.95
                context.addFilter(.blur(radius: config.blurRadius))
                context.fill(mainPath, with: .color(model.colors[i]))
            }
            
            let splashes = Path { path in
                for _ in 0..<config.numberOfSplashes {
                    let x = CGFloat.random(in: -10...size.width+10)
                    let y = CGFloat.random(in: -10...size.height+10)
                    let size = CGFloat.random(in: 1...8)
                    let randomAngle = CGFloat.random(in: 0...(2 * .pi))
                    
                    path.move(to: CGPoint(x: x, y: y))
                    path.addArc(center: CGPoint(x: x, y: y),
                                radius: size,
                                startAngle: Angle(radians: randomAngle),
                                endAngle: Angle(radians: randomAngle + .pi * 1.7),
                                clockwise: Bool.random())
                }
            }
            
            context.blendMode = .normal
            context.opacity = 0.98
            context.fill(splashes, with: .color(model.colors[1]))
            
            for _ in 0..<config.numberOfStrokes {
                let strokePath = Path { path in
                    let startX = CGFloat.random(in: -10...size.width+10)
                    let startY = CGFloat.random(in: -10...size.height+10)
                    path.move(to: CGPoint(x: startX, y: startY))
                    
                    for _ in 0..<3 {
                        let endX = startX + CGFloat.random(in: -20...20)
                        let endY = startY + CGFloat.random(in: -20...20)
                        let controlX = (startX + endX)/2 + CGFloat.random(in: -10...10)
                        let controlY = (startY + endY)/2 + CGFloat.random(in: -10...10)
                        
                        path.addQuadCurve(
                            to: CGPoint(x: endX, y: endY),
                            control: CGPoint(x: controlX, y: controlY)
                        )
                    }
                }

                context.blendMode = .normal
                context.opacity = CGFloat.random(in: 0.6...0.8)
                context.stroke(strokePath, with: .color(.white), lineWidth: CGFloat.random(in: 0.5...2))
            }
        }
        .frame(width: size.width, height: size.height)
    }
}
