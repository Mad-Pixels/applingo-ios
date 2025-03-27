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
    
    /// Applies an animated dynamic pattern border to the view.
        /// - Parameters:
        ///   - model: The model defining the dynamic pattern.
        ///   - size: The size of the pattern.
        ///   - cornerRadius: The corner radius for the border.
        ///   - minScale: The minimum scale factor for the animation.
        ///   - animationDuration: The duration of one animation cycle.
        ///   - borderWidth: The width of the border.
        /// - Returns: A view with the animated border applied.
        func animatedBorder(
            model: DynamicPatternModel,
            size: CGSize,
            cornerRadius: CGFloat,
            minScale: CGFloat,
            animationDuration: Double,
            borderWidth: CGFloat
        ) -> some View {
            self.modifier(AnimatedBorderModifier(
                model: model,
                size: size,
                cornerRadius: cornerRadius,
                minScale: minScale,
                animationDuration: animationDuration,
                borderWidth: borderWidth
            ))
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
    
    
    
    /// Applies an animated dynamic background pattern to the view.
        /// - Parameters:
        ///   - model: The model defining the dynamic pattern.
        ///   - size: The size of the pattern.
        ///   - cornerRadius: The corner radius used for masking the pattern.
        ///   - minScale: The minimum scale factor for the animation.
        ///   - opacity: The opacity applied to the pattern.
        ///   - animationDuration: The duration of one animation cycle.
        /// - Returns: A view with the animated background pattern applied.
        func animatedBackground(
            model: DynamicPatternModel,
            size: CGSize,
            cornerRadius: CGFloat,
            minScale: CGFloat,
            opacity: CGFloat,
            animationDuration: Double
        ) -> some View {
            self.modifier(AnimatedBackgroundModifier(
                model: model,
                size: size,
                cornerRadius: cornerRadius,
                minScale: minScale,
                opacity: opacity,
                animationDuration: animationDuration
            ))
        }
}
