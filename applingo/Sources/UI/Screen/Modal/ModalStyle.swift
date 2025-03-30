import SwiftUI

final class ModalStyle: ObservableObject {
    // Colors
    let dimBackgroundColor: Color
    let modalBackgroundColor: Color

    // Layout & Dimensions
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    let windowWidth: CGFloat
    let windowHeight: CGFloat

    // Effects
    let shadowRadius: CGFloat
    let animation: Animation

    // Initializer
    init(
        dimBackgroundColor: Color,
        modalBackgroundColor: Color,
        padding: EdgeInsets,
        cornerRadius: CGFloat,
        shadowRadius: CGFloat,
        animation: Animation,
        windowWidth: CGFloat,
        windowHeight: CGFloat
    ) {
        self.dimBackgroundColor = dimBackgroundColor
        self.modalBackgroundColor = modalBackgroundColor
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.animation = animation
        self.windowWidth = windowWidth
        self.windowHeight = windowHeight
    }
}

extension ModalStyle {
    static func themed(_ theme: AppTheme) -> ModalStyle {
        let screen = UIScreen.main.bounds
        
        return ModalStyle(
            dimBackgroundColor: Color.black.opacity(0.5),
            modalBackgroundColor: theme.backgroundPrimary,
            padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            cornerRadius: 16,
            shadowRadius: 10,
            animation: .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5),
            windowWidth: screen.width * 0.8,
            windowHeight: screen.height * 0.8
        )
    }
}
