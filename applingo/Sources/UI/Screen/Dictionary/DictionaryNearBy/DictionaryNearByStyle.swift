import SwiftUI

final class DictionarySendStyle: ObservableObject {
    let spacing: CGFloat

    init(spacing: CGFloat) {
        self.spacing = spacing
    }
}

extension DictionarySendStyle {
    static func themed(_ theme: AppTheme) -> DictionarySendStyle {
        DictionarySendStyle(spacing: 20)
    }
}
