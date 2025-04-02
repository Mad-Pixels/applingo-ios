import SwiftUI

// Used in games like visual game feedback actions.
extension ButtonActionStyle {
    /// Change button background color feedback.
    static func GameAnswer(_ theme: AppTheme, highlightColor: Color) -> ButtonActionStyle {
        var style = game(theme)
        style.backgroundColor = highlightColor
        return style
    }
}
