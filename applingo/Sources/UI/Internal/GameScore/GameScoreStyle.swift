import SwiftUI

/// A style object for configuring the appearance and animations of the game score view.
final class GameScoreStyle: ObservableObject {
    // MARK: - Visual Properties
    let positiveTextColor: Color
    let negativeTextColor: Color
    let iconSize: CGFloat
    let font: Font

    // MARK: - Animation Properties
    /// Maximum number of score history items to display simultaneously.
    let maxAnimationItems: Int
    /// Ratio used to fade older score entries.
    let fadeRatio: Double
    /// Vertical offset step for each subsequent score entry.
    let offsetStep: CGFloat
    /// Scale factor for older score entries.
    let scaleRatio: CGFloat
    /// Base duration for score animations.
    let baseAnimationDuration: Double
    /// Duration the score remains visible before removal.
    let displayDuration: Double
    /// Duration of the removal animation.
    let removalDuration: Double
    /// Delay before the removal animation begins.
    let removalDelay: Double
    
    // MARK: - Text Saturation
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

// MARK: - Themed Style Extension
extension GameScoreStyle {
    /// Returns a themed style based on the current application theme.
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `GameScoreStyle` configured for the given theme,
    ///            with animation values set directly.
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
