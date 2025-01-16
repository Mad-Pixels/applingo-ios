import SwiftUI

struct ItemPickerStyle {
    let backgroundColor: Color
    let accentColor: Color
    let type: PickerType
    let spacing: CGFloat
    
    enum PickerType {
        case wheel
        case segmented
        case menu
        case inline
    }
}

extension ItemPickerStyle {
    static func themed(_ theme: AppTheme, type: PickerType = .wheel) -> ItemPickerStyle {
        ItemPickerStyle(
            backgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            type: type,
            spacing: 8
        )
    }
}
