import SwiftUI

struct DynamicPaletteConfig {
    let opacities: [CGFloat]
    let numberOfPaths: Int
    let numberOfSplashes: Int
    let numberOfStrokes: Int
    let blurRadius: CGFloat
    let maxRadius: CGFloat
    let minRadius: CGFloat

    static let `default` = DynamicPaletteConfig(
        opacities: [0.95, 0.9, 0.98],
        numberOfPaths: 8,
        numberOfSplashes: 50,
        numberOfStrokes: 25,
        blurRadius: 0.5,
        maxRadius: 50,
        minRadius: 10
    )
}
