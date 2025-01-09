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
    static var `default`: AppPickerStyle {
        AppPickerStyle(
            titleColor: .primary,
            backgroundColor: .clear,
            accentColor: .blue,
            type: .wheel,
            spacing: 8
        )
    }
    
    static var segmented: AppPickerStyle {
        AppPickerStyle(
            titleColor: .primary,
            backgroundColor: .clear,
            accentColor: .blue,
            type: .segmented,
            spacing: 8
        )
    }
    
    static var menu: AppPickerStyle {
        AppPickerStyle(
            titleColor: .primary,
            backgroundColor: .clear,
            accentColor: .blue,
            type: .menu,
            spacing: 8
        )
    }
    
    static var inline: AppPickerStyle {
        AppPickerStyle(
            titleColor: .primary,
            backgroundColor: .clear,
            accentColor: .blue,
            type: .inline,
            spacing: 8
        )
    }
}
