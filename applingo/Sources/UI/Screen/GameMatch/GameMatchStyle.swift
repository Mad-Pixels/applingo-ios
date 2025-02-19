import SwiftUI

final class GameMatchStyle: ObservableObject {
    let backgroundColor: Color
    
    init(
        backgroundColor: Color
    ) {
        self.backgroundColor = backgroundColor
    }
}

extension GameMatchStyle {
    static func themed(_ theme: AppTheme) -> GameMatchStyle {
        GameMatchStyle(
            backgroundColor: theme.backgroundPrimary
        )
    }
}
