import SwiftUI

extension ButtonActionStyle {
    static func incorrectGameAnswer(_ theme: AppTheme, highlightColor: Color) -> ButtonActionStyle {
        var style = game(theme)
        style.backgroundColor = highlightColor
        return style
    }
}
