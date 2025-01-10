import SwiftUI

struct AppPickerStyle {
    let titleColor: Color
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

extension AppPickerStyle {
    static func themed(_ theme: AppTheme, type: PickerType = .wheel) -> AppPickerStyle {
        AppPickerStyle(
            titleColor: theme.textPrimary,
            backgroundColor: .clear,
            accentColor: theme.accentPrimary,
            type: type,
            spacing: 8
        )
    }
}
