import SwiftUI

final class GameQuizStyle: ObservableObject {
    let backgroundColor: Color
    
    init(
        backgroundColor: Color
    ) {
        self.backgroundColor = backgroundColor
    }
}

extension GameQuizStyle {
    static func themed(_ theme: AppTheme) -> GameQuizStyle {
        GameQuizStyle(
            backgroundColor: theme.accentPrimary
        )
    }
}
