import SwiftUI

struct SectionHeader: View {
    let style: SectionHeaderStyle
    let title: String
    
    /// Initializes the SectionHeader.
    /// - Parameters:
    ///   - title: The header title.
    ///   - style: The styling for the header. Defaults to themed style using the current theme.
    init(
        title: String,
        style: SectionHeaderStyle = .block(ThemeManager.shared.currentThemeStyle)
    ) {
        self.title = title
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            DynamicText(
                model: DynamicTextModel(text: title),
                style: style.textStyle(
                    ThemeManager.shared.currentThemeStyle
                )
            )
            
            Rectangle()
                .fill(style.separatorColor)
                .frame(height: 0.5)
        }
        .padding(.bottom, style.padding.bottom)
    }
}
