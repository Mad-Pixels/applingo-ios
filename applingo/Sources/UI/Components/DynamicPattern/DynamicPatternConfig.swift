import SwiftUI

/// Configuration for the dynamic pattern.
struct DynamicPatternConfig {
    let opacities: [CGFloat]
    let numberOfPaths: Int
    let numberOfSplashes: Int
    let numberOfStrokes: Int
    let blurRadius: CGFloat
    let maxRadius: CGFloat
    let minRadius: CGFloat

    /// Default configuration values.
    static let `default` = DynamicPatternConfig(
        opacities: [0.95, 0.9, 0.98],
        numberOfPaths: 8,
        numberOfSplashes: 50,
        numberOfStrokes: 25,
        blurRadius: 0.5,
        maxRadius: 50,
        minRadius: 10
    )
}
