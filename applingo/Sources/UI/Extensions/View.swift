import SwiftUI

extension View {
    /// Adds an overlay with a centered modal window on top of the current view.
    ///
    /// This modifier displays a modal window overlay when the provided binding is `true`.
    /// You can customize the modal's appearance by passing an optional `ModalWindowStyle`.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the modal window is visible.
    ///   - style: An optional modal window style. If `nil`, the default themed style is applied.
    ///   - modalContent: A ViewBuilder closure that constructs the content to be displayed inside the modal window.
    ///
    /// - Returns: A view with an overlay that presents the modal window centered on the screen.
    func showModal<Content: View>(
        isPresented: Binding<Bool>,
        style: ModalWindowStyle? = nil,
        @ViewBuilder modalContent: @escaping () -> Content
    ) -> some View {
        self.overlay(
            ModalWindow(isPresented: isPresented, style: style, content: modalContent)
        )
    }
    
    func glassBackground(
        cornerRadius: CGFloat = 16,
        opacity: CGFloat = 0.85
    ) -> some View {
        let adjustedOpacity = ThemeManager.shared.currentTheme == .dark ? opacity : 0.98 // фиксированное значение для светлой темы
        return modifier(GlassBackgroundModifier(
            cornerRadius: cornerRadius,
            opacity: adjustedOpacity
        ))
    }
}
