import SwiftUI

/// A view that displays the provided text using a dynamic style that adjusts font size, weight, and other attributes.
///
/// The view computes an optimal font size based on the text's complexity (using a cached value if available),
/// applies appropriate styling, and animates any changes in the text.
struct DynamicText: View {
    let model: DynamicTextModel
    let style: DynamicTextStyle
    
    /// Computes the optimal font size for the text, utilizing a cache to avoid redundant calculations.
    private var optimalFontSize: CGFloat {
        let size = style.calculateOptimalFontSize(for: model.text)
        TextSizeCache.cacheSize(size, for: model.text)
        return size
    }
    
    /// Creates an attributed version of the text with the computed font size, weight, and color.
    private var attributedText: AttributedString {
        var attributed = AttributedString(model.text)
        attributed.font = .system(
            size: optimalFontSize,
            weight: calculateFontWeight(for: model.text)
        )
        attributed.foregroundColor = style.textColor
        return attributed
    }
    
    var body: some View {
        Text(attributedText)
            .multilineTextAlignment(style.alignment)
            .tracking(style.letterSpacing)
            .allowsTightening(style.allowsTightening)
            .minimumScaleFactor(style.minFontSize / optimalFontSize)
            .fixedSize(horizontal: false, vertical: true)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: model.text)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 8)
    }
}

// MARK: - Private Methods
/// Calculates an appropriate font weight based on the length of the text.
///
/// - Parameter text: The text whose font weight is to be determined.
/// - Returns: A `Font.Weight` value suitable for the text.
private func calculateFontWeight(for text: String) -> Font.Weight {
    switch text.count {
    case 0...20:   return .bold       // Short text – bold.
    case 21...50:  return .semibold   // Medium text – semibold.
    case 51...100: return .medium     // Long text – medium.
    default:       return .regular    // Very long text – regular.
    }
}
