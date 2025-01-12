import SwiftUI

final class ScreenLearnStyle: ObservableObject {
    let backgroundColor: Color
    let padding: EdgeInsets
    let spacing: CGFloat
    
    init(
        backgroundColor: Color,
        padding: EdgeInsets,
        spacing: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.padding = padding
        self.spacing = spacing
    }
}

extension ScreenLearnStyle {
    static func themed(_ theme: AppTheme) -> ScreenLearnStyle {
        ScreenLearnStyle(
            backgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24),
            spacing: 20
        )
    }
}
