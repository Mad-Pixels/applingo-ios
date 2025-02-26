import SwiftUI

/// Defines styling properties for a centered modal window.
final class ModalWindowStyle: ObservableObject {
    // MARK: - Properties
    
    /// The color used for the dimmed background behind the modal.
    let dimBackgroundColor: Color
    /// The background color of the modal window.
    let modalBackgroundColor: Color
    /// The padding inside the modal.
    let padding: EdgeInsets
    /// The corner radius of the modal window.
    let cornerRadius: CGFloat
    /// The shadow radius applied to the modal.
    let shadowRadius: CGFloat
    /// The animation used for showing/hiding the modal.
    let animation: Animation
    /// The width of the modal window (relative to screen width).
    let windowWidth: CGFloat
    /// The height of the modal window (relative to screen height).
    let windowHeight: CGFloat

    // MARK: - Initializer
    /// Initializes a new instance of `ModalWindowStyle`.
    ///
    /// - Parameters:
    ///   - dimBackgroundColor: The color used for the dimmed background.
    ///   - modalBackgroundColor: The background color of the modal.
    ///   - padding: The padding inside the modal.
    ///   - cornerRadius: The corner radius of the modal.
    ///   - shadowRadius: The shadow radius applied to the modal.
    ///   - animation: The animation for the modal appearance/disappearance.
    ///   - windowWidth: The width of the modal window.
    ///   - windowHeight: The height of the modal window.
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

// MARK: - Themed Style Extension
extension ModalWindowStyle {
    /// Returns a themed style based on the current application theme.
    ///
    /// - Parameter theme: The current application theme.
    /// - Returns: A new instance of `ModalWindowStyle` configured for the given theme.
    static func themed(_ theme: AppTheme) -> ModalWindowStyle {
        let screen = UIScreen.main.bounds
        
        return ModalWindowStyle(
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
