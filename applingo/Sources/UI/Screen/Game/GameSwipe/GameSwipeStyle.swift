import SwiftUI

final class GameSwipeStyle: ObservableObject {
    // Layouts
    let floatingBtnPadding: CGFloat
    
    let backgroundColor: Color
    
    init(
        floatingBtnPadding: CGFloat,
        backgroundColor: Color
        
    ) {
        self.floatingBtnPadding = floatingBtnPadding
        self.backgroundColor = backgroundColor
    }
}

extension GameSwipeStyle {
    static func themed(_ theme: AppTheme) -> GameSwipeStyle {
        GameSwipeStyle(
            floatingBtnPadding: 32,
            backgroundColor: theme.backgroundPrimary
        )
    }
}
