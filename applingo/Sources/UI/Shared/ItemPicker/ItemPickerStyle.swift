import SwiftUI

// MARK: - ItemPickerStyle
/// Defines the styling parameters for ItemPicker.
struct ItemPickerStyle {
    let backgroundColor: Color
    let accentColor: Color
    let type: PickerType
    let spacing: CGFloat
    
    /// Picker type options.
    enum PickerType {
        case wheel
        case segmented
        case menu
        case inline
    }
}

extension ItemPickerStyle {
    /// Returns a themed style based on the provided AppTheme.
    static func themed(_ theme: AppTheme, type: PickerType = .wheel) -> ItemPickerStyle {
        ItemPickerStyle(
            backgroundColor: theme.backgroundSecondary,
            accentColor: theme.accentPrimary,
            type: type,
            spacing: 8
        )
    }
}
