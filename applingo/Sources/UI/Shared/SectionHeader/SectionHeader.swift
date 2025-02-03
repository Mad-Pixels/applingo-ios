import SwiftUI

// MARK: - SectionHeader View
/// Displays a header with a title and an optional separator.
struct SectionHeader: View {
    let title: String
    let style: SectionHeaderStyle

    /// Initializes the section header.
    /// - Parameters:
    ///   - title: The header title.
    ///   - style: The styling for the header. Defaults to themed style using the current theme.
    init(
        title: String,
        style: SectionHeaderStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.title = title
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            Text(title)
                .font(style.titleFont)
                .foregroundColor(style.titleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, style.padding.leading)
            
            Rectangle()
                .fill(style.separatorColor)
                .frame(height: 0.5)
        }
        .padding(.bottom, style.padding.bottom)
    }
}
