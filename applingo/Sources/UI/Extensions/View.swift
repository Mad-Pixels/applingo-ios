import SwiftUI

extension View {
    // MARK: - Conditional Modifiers

    /// Applies a transformation only if the given condition is true.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }

    /// Applies a transformation only if iOS 17 or newer is available.
    @ViewBuilder
    func ifIOS17<Content: View>(_ apply: (Self) -> Content) -> some View {
        if #available(iOS 17, *) {
            apply(self)
        } else {
            self
        }
    }

    /// Applies a transformation only if iOS 18 or newer is available.
    @ViewBuilder
    func ifIOS18<Content: View>(_ apply: (Self) -> Content) -> some View {
        if #available(iOS 18, *) {
            apply(self)
        } else {
            self
        }
    }

    // MARK: - Modals

    /// Adds an overlay with a centered modal window on top of the current view.
    func showModal<Content: View>(
        isPresented: Binding<Bool>,
        style: ModalStyle,
        @ViewBuilder modalContent: @escaping () -> Content
    ) -> some View {
        self.overlay(
            ModalWindow(isPresented: isPresented, style: style, content: modalContent)
        )
    }

    // MARK: - Effects

    /// Applies an animated dynamic pattern border to the view.
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

    /// Applies an animated dynamic background pattern to the view.
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

    /// Applies a wave effect to the view.
    func waveEffect(
        isActive: Bool,
        colors: [Color] = [.blue, .purple, .cyan],
        radius: CGFloat = 15
    ) -> some View {
        self.modifier(WaveEffect(isActive: isActive, colors: colors, radius: radius))
    }

    /// Applies a glass background style to the view.
    func glassBackground(
        cornerRadius: CGFloat = 16,
        opacity: CGFloat = 0.85
    ) -> some View {
        let adjustedOpacity = ThemeManager.shared.currentTheme == .dark ? opacity : 0.98
        return modifier(StyleGlassModifier(
            cornerRadius: cornerRadius,
            opacity: adjustedOpacity
        ))
    }

    // MARK: - Trackers

    /// Applies the error tracker to the view.
    func withErrorTracker(_ screen: ScreenType) -> some View {
        modifier(TrackerErrorModifier(screen: screen))
    }

    /// Applies the locale tracker to the view.
    func withLocaleTracker() -> some View {
        modifier(TrackerLocaleModifier())
    }

    /// Applies the screen tracker to the view.
    func withScreenTracker(_ screen: ScreenType) -> some View {
        modifier(TrackerScreenModifier(screen: screen))
    }

    /// Applies the theme tracker to the view.
    func withThemeTracker() -> some View {
        modifier(TrackerThemeModifier())
    }
}
