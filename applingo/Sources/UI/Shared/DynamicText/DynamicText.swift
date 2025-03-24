import SwiftUI

/// A view that displays the provided text using a dynamic style that adjusts font size, weight, and other attributes.
/// The view computes an optimal font size based on the text's complexity (using a cached value if available),
/// applies appropriate styling, and animates any changes in the text.
struct DynamicText: View {
    let model: DynamicTextModel
    let style: DynamicTextStyle
    
    /// Computes the optimal font size for the text.
    private var optimalFontSize: CGFloat {
        style.calculateOptimalFontSize(for: model.text)
    }
    
    /// Creates an attributed version of the text with the computed font size, weight, and color.
    private var attributedText: AttributedString {
        var attributed = AttributedString(model.text)
        attributed.font = .system(size: optimalFontSize, weight: style.fontWeight)
        attributed.foregroundColor = style.textColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = style.lineBreakMode
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: optimalFontSize, weight: uiFontWeight(for: style.fontWeight)),
            .foregroundColor: UIColor(style.textColor)
        ]
        
        let nsAttributedString = NSAttributedString(string: model.text, attributes: attributes)
        attributed = AttributedString(nsAttributedString)
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
            .lineLimit(style.lineLimit)
            .frame(maxWidth: .infinity, alignment: textAlignment(from: style.alignment))
    }
    
    /// Converts a SwiftUI Font.Weight into a UIFont.Weight.
    private func uiFontWeight(for weight: Font.Weight) -> UIFont.Weight {
        switch weight {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return .regular
        }
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

private func textAlignment(from alignment: TextAlignment) -> Alignment {
    switch alignment {
    case .leading:
        return .leading
    case .center:
        return .center
    case .trailing:
        return .trailing
    }
}
