import SwiftUI

struct SectionHeaderStyle {
    // Appearance Properties
    let separatorColor: Color
    
    // Layout Properties
    let spacing: CGFloat
    let padding: EdgeInsets
    
    // Text Styling
    let textStyle: (AppTheme) -> DynamicTextStyle
    
    init(
        separatorColor: Color,
        spacing: CGFloat,
        padding: EdgeInsets,
        textStyle: @escaping (AppTheme) -> DynamicTextStyle
    ) {
        self.separatorColor = separatorColor
        self.spacing = spacing
        self.padding = padding
        self.textStyle = textStyle
    }
}

extension SectionHeaderStyle {
    static func block(_ theme: AppTheme) -> SectionHeaderStyle {
        SectionHeaderStyle(
            separatorColor: theme.textSecondary.opacity(0.15),
            spacing: 8,
            padding: EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16),
            textStyle: { theme in
                .headerBlock(
                    theme,
                    alignment: .leading,
                    lineLimit: 1
                )
            }
        )
    }
}
