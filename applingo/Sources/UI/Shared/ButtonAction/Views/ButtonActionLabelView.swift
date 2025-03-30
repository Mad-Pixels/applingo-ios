import SwiftUI

internal struct ButtonActionLabelView: View {
    internal let title: String
    internal let style: ButtonActionStyle
    
    var body: some View {
        DynamicText(
            model: DynamicTextModel(text: title),
            style: style.textStyle(
                ThemeManager.shared.currentThemeStyle
            )
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
