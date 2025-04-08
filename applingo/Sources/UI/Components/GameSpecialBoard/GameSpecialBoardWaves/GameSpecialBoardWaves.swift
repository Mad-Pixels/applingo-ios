import SwiftUI

struct GameSpecialBoardWaves: View {
    @State private var phase = 0.0
    
    let style: GameSpecialBoardWavesStyle
    
    init(style: GameSpecialBoardWavesStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<style.waveCount, id: \.self) { i in
                    GameSpecialBoardWave(
                        frequency: style.frequencies[i % style.frequencies.count],
                        amplitude: style.amplitudes[i % style.amplitudes.count],
                        phase: phase
                    )
                    .stroke(
                        style.waveColors[i % style.waveColors.count],
                        style: StrokeStyle(lineWidth: style.lineWidths[i % style.lineWidths.count])
                    )
                    .opacity(style.waveOpacity)
                    .frame(width: geo.size.width, height: geo.size.height / CGFloat(style.waveCount - 1))
                    .position(
                        x: geo.size.width / 2,
                        y: (geo.size.height / CGFloat(style.waveCount - 1)) * CGFloat(i) + (geo.size.height / CGFloat(style.waveCount - 1)) / 2
                    )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.linear(duration: style.animationDuration).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}


