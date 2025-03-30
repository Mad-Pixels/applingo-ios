import SwiftUI

struct ItemPickerStyle {
    // Appearance Properties
    let backgroundColor: Color
    let accentColor: Color
    
    // Behavior Properties
    let type: ItemPickerType
    
    // Layout Properties
    let spacing: CGFloat
}

extension ItemPickerStyle {
    static func themed(_ theme: AppTheme, type: ItemPickerType = .wheel) -> ItemPickerStyle {
        ItemPickerStyle(
            backgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            type: type,
            spacing: 8
        )
    }
}
