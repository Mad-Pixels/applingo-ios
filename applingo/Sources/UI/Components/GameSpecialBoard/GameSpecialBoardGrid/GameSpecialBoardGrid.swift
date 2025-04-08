import SwiftUI

struct GameSpecialBoardGrid: View {
    @State private var animate = false
    
    let style: GameSpecialBoardGridStyle
    
    init(style: GameSpecialBoardGridStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            let columns = Int(ceil(geo.size.width / style.gridSpacing)) + 2
            let rows = Int(ceil(geo.size.height / style.gridSpacing)) + 2
            
            let offsetX = (CGFloat(columns) * style.gridSpacing - geo.size.width) / 2
            
            ZStack {
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        let index = row * columns + column
                        Circle()
                            .fill(style.gridColors[index % style.gridColors.count].opacity(style.gridOpacity))
                            .frame(width: animate ? style.maxDotSize : style.minDotSize,
                                   height: animate ? style.maxDotSize : style.minDotSize)
                            .position(
                                x: CGFloat(column) * style.gridSpacing - offsetX,
                                y: CGFloat(row) * style.gridSpacing
                            )
                            .animation(
                                .easeInOut(duration: style.animationDuration)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double((row + column) % style.phaseCount) * style.animationDelayStep),
                                value: animate
                            )
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animate = true
        }
        .drawingGroup()
    }
}
