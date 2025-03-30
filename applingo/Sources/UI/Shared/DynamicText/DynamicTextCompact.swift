import SwiftUI

struct DynamicTextCompact: View {
    let model: DynamicTextModel
    let style: DynamicTextStyle
    
    private var optimalFontSize: CGFloat {
        style.calculateOptimalFontSize(for: model.text)
    }
    
    var body: some View {
        Text(model.text)
            .font(.system(size: optimalFontSize, weight: style.fontWeight, design: style.fontDesign))
            .foregroundColor(style.textColor)
            .multilineTextAlignment(style.alignment)
            .tracking(style.letterSpacing)
            .allowsTightening(style.allowsTightening)
            .lineLimit(style.lineLimit)
            .minimumScaleFactor(style.minFontSize / optimalFontSize)
            .animation(.easeInOut(duration: 0.3), value: model)
    }
}
