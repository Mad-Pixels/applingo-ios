import SwiftUI

final class GameScoreStyle: ObservableObject {
    // Visual Properties
    let positiveTextColor: Color
    let negativeTextColor: Color
    let iconSize: CGFloat
    let font: Font

    // Animation Properties
    let maxAnimationItems: Int
    let fadeRatio: Double
    let offsetStep: CGFloat
    let scaleRatio: CGFloat
    let baseAnimationDuration: Double
    let displayDuration: Double
    let removalDuration: Double
    let removalDelay: Double
    
    // Text Saturation
    let minSaturation: Double
    let saturationStep: Double

    // MARK: - Initializer
    /// Initializes a new instance of `GameScoreStyle`.
    /// - Parameters:
    ///   - positiveTextColor: The color for positive score values.
    ///   - negativeTextColor: The color for negative score values.
    ///   - iconSize: The size of the icon.
    ///   - font: The font used for displaying the score.
    ///   - maxAnimationItems: Maximum history items to display.
    ///   - fadeRatio: The ratio to fade older items.
    ///   - offsetStep: The vertical offset added per item.
    ///   - scaleRatio: The scaling factor for older items.
    ///   - baseAnimationDuration: The base animation duration.
    ///   - displayDuration: The duration the score remains visible.
    ///   - removalDuration: The duration of the removal animation.
    ///   - removalDelay: The delay before removal starts.
    init(
        positiveTextColor: Color,
        negativeTextColor: Color,
        iconSize: CGFloat,
        font: Font,
        maxAnimationItems: Int,
        fadeRatio: Double,
        offsetStep: CGFloat,
        scaleRatio: CGFloat,
        baseAnimationDuration: Double,
        displayDuration: Double,
        removalDuration: Double,
        removalDelay: Double,
        saturationStep: Double,
        minSaturation: Double
    ) {
        self.positiveTextColor = positiveTextColor
        self.negativeTextColor = negativeTextColor
        self.iconSize = iconSize
        self.font = font
        self.maxAnimationItems = maxAnimationItems
        self.fadeRatio = fadeRatio
        self.offsetStep = offsetStep
        self.scaleRatio = scaleRatio
        self.baseAnimationDuration = baseAnimationDuration
        self.displayDuration = displayDuration
        self.removalDuration = removalDuration
        self.removalDelay = removalDelay
        self.saturationStep = saturationStep
        self.minSaturation = minSaturation
    }
}

extension GameScoreStyle {
    static func themed(_ theme: AppTheme) -> GameScoreStyle {
        GameScoreStyle(
            positiveTextColor: theme.success,
            negativeTextColor: theme.errorPrimaryColor,
            iconSize: 42,
            font: .system(size: 11, weight: .bold),
            maxAnimationItems: 3,
            fadeRatio: 0.7,
            offsetStep: 12,
            scaleRatio: 0.9,
            baseAnimationDuration: 0.2,
            displayDuration: 2.0,
            removalDuration: 0.25,
            removalDelay: 0.25,
            saturationStep: 0.25,
            minSaturation: 0.5
        )
    }
}
