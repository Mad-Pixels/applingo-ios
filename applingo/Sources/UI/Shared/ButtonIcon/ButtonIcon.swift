import SwiftUI


struct PaintedBackground: View {
   let colors: [Color]
   let size: CGSize
   
   init(colors: [Color] = [
       Color(red: 1.0, green: 0.3, blue: 0.1),  // базовый
       Color(red: 1.0, green: 0.1, blue: 0.05), // контрастный красный
       Color(red: 1.0, green: 0.45, blue: 0.15),// оранжевый
       Color(red: 0.95, green: 0.15, blue: 0.1) // темно-красный
   ], size: CGSize) {
       self.colors = colors
       self.size = size
   }

   var body: some View {
       Canvas { context, _ in
           // Яркий базовый слой
           context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(colors[0]))
           
           // Контрастные слои с минимальным размытием
           let opacities: [CGFloat] = [0.95, 0.9, 0.98]
           
           for i in 1..<min(colors.count, 4) {
               let mainPath = Path { path in
                   for _ in 0..<8 {
                       let x = CGFloat.random(in: -50...size.width+50)
                       let y = CGFloat.random(in: -50...size.height+50)
                       var points: [CGPoint] = []
                       
                       for angle in stride(from: 0, to: 360, by: 30) {
                           let radian = Double(angle) * .pi / 180
                           let radius = CGFloat.random(in: 20...80)
                           let px = x + cos(radian) * radius * CGFloat.random(in: 0.5...1.5)
                           let py = y + sin(radian) * radius * CGFloat.random(in: 0.5...1.5)
                           points.append(CGPoint(x: px, y: py))
                       }
                       
                       path.move(to: points[0])
                       for i in 0..<points.count {
                           let control = CGPoint(
                               x: points[i].x + CGFloat.random(in: -30...30),
                               y: points[i].y + CGFloat.random(in: -30...30)
                           )
                           path.addQuadCurve(
                               to: points[(i + 1) % points.count],
                               control: control
                           )
                       }
                   }
               }
               
               context.blendMode = .plusLighter
               context.opacity = opacities[i-1]
               context.addFilter(.blur(radius: 0.5))
               context.fill(mainPath, with: .color(colors[i]))
           }
           
           // Яркие брызги без размытия
           let splashes = Path { path in
               for _ in 0..<50 {
                   let x = CGFloat.random(in: -20...size.width+20)
                   let y = CGFloat.random(in: -20...size.height+20)
                   let size = CGFloat.random(in: 2...15)
                   let randomAngle = CGFloat.random(in: 0...(2 * .pi))
                   
                   path.move(to: CGPoint(x: x, y: y))
                   path.addArc(center: CGPoint(x: x, y: y),
                             radius: size,
                             startAngle: Angle(radians: randomAngle),
                             endAngle: Angle(radians: randomAngle + .pi * 1.7),
                             clockwise: Bool.random())
               }
           }
           
           context.blendMode = .plusLighter
           context.opacity = 0.95
           context.fill(splashes, with: .color(colors[1]))
           
           // Темные акценты для глубины
           let darkAccents = Path { path in
               for _ in 0..<35 {
                   let x = CGFloat.random(in: 0...size.width)
                   let y = CGFloat.random(in: 0...size.height)
                   path.addEllipse(in: CGRect(x: x, y: y, width: 3, height: 3))
               }
           }
           
           context.blendMode = .multiply
           context.opacity = 0.4
           context.fill(darkAccents, with: .color(.black))
           
           // Текстурные штрихи
           for _ in 0..<25 {
               let strokePath = Path { path in
                   let startX = CGFloat.random(in: -20...size.width+20)
                   let startY = CGFloat.random(in: -20...size.height+20)
                   path.move(to: CGPoint(x: startX, y: startY))
                   
                   for _ in 0..<3 {
                       let endX = startX + CGFloat.random(in: -40...40)
                       let endY = startY + CGFloat.random(in: -40...40)
                       let controlX = (startX + endX)/2 + CGFloat.random(in: -20...20)
                       let controlY = (startY + endY)/2 + CGFloat.random(in: -20...20)
                       
                       path.addQuadCurve(
                           to: CGPoint(x: endX, y: endY),
                           control: CGPoint(x: controlX, y: controlY)
                       )
                   }
               }
               
               context.blendMode = .plusDarker
               context.opacity = CGFloat.random(in: 0.4...0.7)
               context.stroke(strokePath, with: .color(.white), lineWidth: CGFloat.random(in: 1...3))
           }
       }
       .frame(width: size.width, height: size.height)
   }
}

import SwiftUI

struct ButtonIcon: View {
    let title: String
    let icon: String
    let color: Color
    let style: ButtonIconStyle
    let action: () -> Void

    init(
        title: String,
        icon: String,
        color: Color = ThemeManager.shared.currentThemeStyle.accentPrimary,
        action: @escaping () -> Void = {},
        style: ButtonIconStyle = .themed(ThemeManager.shared.currentThemeStyle, color: ThemeManager.shared.currentThemeStyle.accentPrimary)
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .trailing) {
                Image(systemName: icon)
                    .font(.system(size: style.iconSize))
                    .rotationEffect(.degrees(style.iconRotation))
                    .foregroundColor(style.iconColor)
                    .frame(width: 100)
                    .offset(x: 25)
                
                HStack {
                    Text(title.uppercased())
                        .font(style.font)
                        .foregroundColor(style.foregroundColor)
                    Spacer()
                }
                .padding(style.padding)
            }
            .frame(maxWidth: .infinity)
            .frame(height: style.height)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .overlay(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .strokeBorder(.clear, lineWidth: 5)
                        .background(
                            PaintedBackground(
                                colors: [
                                    Color(red: 0.9, green: 0.7, blue: 0.9), // Светло-розовый
                                    Color(red: 0.7, green: 0.9, blue: 0.9), // Светло-голубой
                                    Color(red: 0.9, green: 0.9, blue: 0.7)  // Светло-желтый
                                ],
                                size: CGSize(width: geometry.size.width * 2, height: geometry.size.height * 2)
                            )
                        )
                        .mask(
                            RoundedRectangle(cornerRadius: style.cornerRadius)
                                .strokeBorder(style: StrokeStyle(lineWidth: 5))
                        )
                }
            )
            .scaleEffect(style.highlightOnPress ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: style.highlightOnPress)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
