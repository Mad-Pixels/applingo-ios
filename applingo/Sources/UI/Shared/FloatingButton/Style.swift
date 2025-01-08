import SwiftUI

struct FloatingButtonStyle {
    let mainButtonColor: Color
    let itemButtonColor: Color
    let mainButtonSize: CGSize
    let itemButtonSize: CGSize
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowRadius: CGFloat
}

// Default
extension FloatingButtonStyle {
    static var `default`: FloatingButtonStyle {
        FloatingButtonStyle(
            mainButtonColor: .blue,
            itemButtonColor: .blue,
            mainButtonSize: CGSize(width: 60, height: 60),
            itemButtonSize: CGSize(width: 50, height: 50),
            spacing: 10,
            cornerRadius: 30,
            shadowColor: .black.opacity(0.3),
            shadowRadius: 5
        )
    }
}
