import SwiftUI

struct AppToggleStyle {
    let titleColor: Color
    let headerColor: Color
    let tintColor: Color
    let backgroundColor: Color
    let spacing: CGFloat
    let showHeader: Bool
}

extension AppToggleStyle {
    static var `default`: AppToggleStyle {
        AppToggleStyle(
            titleColor: .primary,
            headerColor: .secondary,
            tintColor: .blue,
            backgroundColor: .clear,
            spacing: 8,
            showHeader: true
        )
    }
    
    static var compact: AppToggleStyle {
        AppToggleStyle(
            titleColor: .primary,
            headerColor: .secondary,
            tintColor: .blue,
            backgroundColor: .clear,
            spacing: 4,
            showHeader: false
        )
    }
}
