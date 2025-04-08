import SwiftUI

struct GameSpecialBoardWavesStyle {
    let waveColors: [Color]
    let waveOpacity: Double
    let waveCount: Int
    let frequencies: [Double]
    let amplitudes: [Double]
    let lineWidths: [CGFloat]
    let animationDuration: Double
}

extension GameSpecialBoardWavesStyle {
    static func themed(_ theme: AppTheme) -> GameSpecialBoardWavesStyle {
        GameSpecialBoardWavesStyle(
            waveColors: [.purple, .blue, .cyan, .teal, .green, .mint],
            waveOpacity: 0.4,
            waveCount: 8,
            frequencies: [1, 1.5, 2, 2.5, 3],
            amplitudes: [0.3, 0.4, 0.5, 0.6, 0.7],
            lineWidths: [2, 2.5, 3, 3.5, 4],
            animationDuration: 6
        )
    }
    
    static func colors(_ theme: AppTheme, colors: [Color]) -> GameSpecialBoardWavesStyle {
        GameSpecialBoardWavesStyle(
            waveColors: colors,
            waveOpacity: 0.4,
            waveCount: 8,
            frequencies: [1, 1.5, 2, 2.5, 3],
            amplitudes: [0.3, 0.4, 0.5, 0.6, 0.7],
            lineWidths: [2, 2.5, 3, 3.5, 4],
            animationDuration: 6
        )
    }
}
